---
name: trestle-compliance-pipeline
description: >-
  Knowledge about end-to-end compliance pipelines using Compliance Trestle: GRC personas and artifact
  ownership, multi-repository coordination, the two-phase component definition authoring pattern,
  CI/CD pipeline integration, and the Compliance-to-Policy (C2P) bridge. Use when users ask about
  compliance pipelines, personas, who owns what artifact, multi-repo workflows, component definition
  dual-mapping (control-to-rule, rule-to-check), CI/CD compliance, C2P, or end-to-end workflow design.
allowed-tools: Bash, Read, Glob, Grep
---

# End-to-End Compliance Pipeline

This skill covers the full compliance pipeline from regulation authoring through assessment results,
including persona ownership, multi-repository coordination, and the Compliance-to-Policy (C2P) bridge
between OSCAL artifacts and runtime policy validation.

## GRC Personas and Artifact Ownership

Each compliance artifact has a primary owner persona and flows downstream to consumers:

| Persona | Primary Artifact | Key Trestle Commands | Downstream Consumer |
|---------|-----------------|---------------------|-------------------|
| Regulators | Catalog | `catalog-generate`, `catalog-assemble` | Compliance Officers |
| Compliance Officers / CISO | Profile | `profile-generate`, `profile-assemble`, `xlsx-to-oscal-profile` | Control Providers, System Owners |
| Control Providers (vendors) | Component Definition (Service) | `csv-to-oscal-cd`, `component-generate`, `component-assemble` | Control Assessors, System Owners |
| Control Assessors (PVP vendors) | Component Definition (Validation) | `csv-to-oscal-cd` (with `Check_Id` column) | CPAC / C2P |
| System Owners / CIO | System Security Plan | `ssp-generate`, `ssp-assemble`, `ssp-filter` | Assessors, Auditors |
| Assessors | Assessment Results | `xccdf-result-to-oscal-ar`, `tanium-result-to-oscal-ar` | CISO, System Owners |
| Operations | Remediation (POA&M) | `create`, `split`, `merge` (JSON workflow) | Auditors |

**Key principle**: Each persona manages their artifact independently. Artifacts flow downstream
via Git-based propagation, enabling separation of duties and independent versioning.

## Per-Persona Authoring Workflows

### Regulators: Catalog Authoring

Regulators publish security controls as catalogs (e.g., NIST 800-53, PCI-DSS, ISO 27001).

```bash
# Import existing catalog or create new one
trestle import -f nist-800-53-catalog.json -o nist-800-53

# Generate markdown for human editing
trestle author catalog-generate --name nist-800-53 --output md_catalogs/nist-800-53

# Edit control markdown files (one per control, grouped by family)
# Then reassemble
trestle author catalog-assemble --markdown md_catalogs/nist-800-53 --output nist-800-53
```

### Compliance Officers: Profile Authoring

Compliance Officers select and tailor controls from catalogs into organization-specific baselines.

```bash
# Generate profile markdown from existing profile
trestle author profile-generate --name my-baseline --output md_profiles/my-baseline

# Edit markdown: adjust parameter values, add guidance sections
# Then reassemble
trestle author profile-assemble --markdown md_profiles/my-baseline --output my-baseline

# Or convert directly from spreadsheet
trestle task xlsx-to-oscal-profile
```

Profiles can import from multiple catalogs and other profiles, creating layered baselines
(e.g., FedRAMP High inherits from NIST 800-53, adding FedRAMP-specific parameters).

### Control Providers: Two-Phase Component Definition

Control Providers (vendors, service providers) declare how their products implement controls.
This is a **two-phase process** — structured rule data via CSV, then narrative responses via markdown.

**Phase 1 — Rules via CSV spreadsheet:**
```bash
# CSV contains: Rule_Id, Rule_Description, Component_Title, Component_Type,
#               Control_Id_List, Parameter_Id, Parameter_Value_Alternatives, ...
trestle task csv-to-oscal-cd
```

The CSV captures structured mappings: which controls map to which technical rules and parameters.
Vendors manage this in spreadsheet tools and commit the CSV to Git.

**Phase 2 — Responses via markdown:**
```bash
# Generate markdown from the component definition created in Phase 1
trestle author component-generate --name my-service --output md_compdefs/my-service

# Edit markdown: write prose responses describing HOW controls are implemented
# Then reassemble
trestle author component-assemble --markdown md_compdefs/my-service --output my-service
```

The markdown captures narrative prose: implementation descriptions, rationale, and status.

**Why the split?** Structured data (rules, parameters, control mappings) is best managed in
spreadsheets. Narrative prose (implementation descriptions) is best edited as markdown.
The two-phase pattern separates these concerns cleanly.

### System Owners: SSP Authoring

System Owners combine profiles and component definitions into a System Security Plan.

```bash
# Generate SSP markdown from profile + component definitions
trestle author ssp-generate --profile my-baseline --compdefs service-a,service-b --output md_ssp/my-system

# Edit markdown: fill in system-specific implementation details, set ssp-values
# Then reassemble
trestle author ssp-assemble --markdown md_ssp/my-system --output my-system

# Filter SSP to a specific profile (for different audit scopes)
trestle author ssp-filter --name my-system --profile fedramp-high --output my-system-fedramp
```

## The Component Definition Bridge

The component definition is the **bridge artifact** that connects regulatory controls to automated
assessment. It operates at two layers via two distinct component types.

### Layer 1: Service Components (Control-to-Rule)

Service components map regulation controls to technology-specific rules and parameters:

```
Control (e.g., AC-2)  -->  Rule (e.g., rule-account-types)  -->  Parameter (e.g., timeout=15min)
```

- **Owner**: Product vendors, service providers
- **CSV columns**: `Rule_Id`, `Rule_Description`, `Control_Id_List`, `Parameter_Id`, `Component_Type=Service`
- **Purpose**: Declares WHAT rules implement a control for a specific technology

### Layer 2: Validation Components (Rule-to-Check)

Validation components map rules to PVP check identifiers:

```
Rule (e.g., rule-account-types)  -->  Check_Id (e.g., test_github.GitHubOrgs.test_members_is_not_empty)
```

- **Owner**: Assessment tool vendors, PVP providers, compliance engineers
- **CSV columns**: `Rule_Id`, `Check_Id`, `Check_Description`, `Component_Type=Validation`
- **Purpose**: Declares HOW a rule is validated by a specific assessment tool

### End-to-End Traceability

Together, the two layers create full traceability:

```
Regulation Control (NIST AC-2)
    --> Service Rule (rule-account-types)
        --> Validation Check (test_github.GitHubOrgs.test_members_is_not_empty)
            --> Assessment Result (pass/fail)
                --> Control Posture (satisfied/not-satisfied)
```

This chain enables automated compliance: given assessment results from PVPs, the system can
automatically compute whether regulatory controls are satisfied by following the mappings backward
through the component definitions.

## Multi-Repository Coordination

### Repository Topology

Large organizations separate artifacts by ownership boundaries:

```
catalog-repo (Regulators)
    |
    v  imports
profile-repo (Compliance Officers)
    |
    v  references
compdef-repo (Vendors / Control Providers)
    |
    v  combined into
ssp-repo (System Owners)
```

Each repository has independent:
- **Versioning**: Catalogs change on regulatory cycles; profiles change on policy review cycles
- **Access control**: Only authorized personas can merge to main
- **CI/CD pipelines**: Each repo validates and assembles its own artifacts

### Change Propagation Pattern

When an upstream artifact changes, downstream repositories receive automated PRs:

1. Upstream merge triggers CI/CD pipeline
2. Pipeline runs `trestle author *-assemble` to produce updated OSCAL JSON
3. CI/CD creates a PR in each downstream repository that imports this artifact
4. Downstream owners review and merge, triggering their own assembly pipelines

Example: A new control is added to the catalog. The profile repo gets a PR to include it.
Once merged, the compdef repo gets a PR to add rule mappings. Once merged, the SSP repo
gets a PR to include the new control responses.

### When to Use Multi-Repo vs Single-Repo

| Factor | Single Repo | Multi-Repo |
|--------|-------------|------------|
| Team size | Small team (1-5 people) | Multiple teams / organizations |
| Ownership | Same team owns all artifacts | Different teams own different artifacts |
| Release cadence | All artifacts change together | Artifacts change independently |
| Access control | Same permissions for all | Different access per artifact type |
| Complexity | Simple, lower overhead | Higher overhead, better separation |

**Recommendation**: Start with a single repo. Split when ownership boundaries become clear
or when independent versioning is needed.

## CI/CD Pipeline Integration

### Pipeline Stages

```
Pre-commit          -->  PR Merge           -->  Post-Merge
trestle validate        trestle author          Propagate to
                        *-assemble              downstream repos
                        (conditional write)
```

**Pre-commit / PR validation:**
```bash
# Validate all models in workspace
trestle validate -a

# Or validate specific model
trestle validate -t catalog -n my-catalog
```

**PR merge / assembly:**
```bash
# Assemble only writes if content changed (prevents unnecessary git churn)
trestle author catalog-assemble --markdown md_catalogs/my-catalog --output my-catalog
trestle author profile-assemble --markdown md_profiles/my-baseline --output my-baseline
trestle author component-assemble --markdown md_compdefs/my-service --output my-service
trestle author ssp-assemble --markdown md_ssp/my-system --output my-system
```

**Post-merge propagation:**
- If the assembled JSON changed, trigger downstream repository updates
- Downstream repos import the new version and run their own assembly

### Write Once, Use Multiple Times

A core principle from the COMPASS architecture: write each compliance artifact once,
then reuse it across multiple contexts:

- **One catalog** serves multiple profiles (FedRAMP High, Moderate, Low all import from NIST 800-53)
- **One component definition** serves multiple SSPs (same service deployed in different systems)
- **One set of PVP checks** validates the same rules across environments (dev, staging, prod)

This avoids duplication and ensures consistency across the compliance program.

## Compliance-to-Policy (C2P)

C2P is a **separate tool** (not part of Trestle) that bridges OSCAL compliance artifacts
to runtime policy validation and back to OSCAL assessment results.

### What C2P Does

```
OSCAL Component Definition
    --> C2P generate_pvp_policy -->  PVP-specific policy config
                                        --> PVP executes checks
    <-- C2P generate_pvp_result <--  PVP-native results
OSCAL Assessment Results
```

C2P reads the component definition's rule-to-check mappings and:
1. **Generates PVP policy**: Configures the PVP with the right checks and parameters
2. **Collects PVP results**: Reads native PVP output after execution
3. **Produces OSCAL Assessment Results**: Maps check pass/fail back to control posture

### Trestle's Role in the C2P Pipeline

Trestle authors the OSCAL artifacts that C2P consumes:
- `csv-to-oscal-cd` creates the component definitions with rule and check mappings
- `component-generate` / `component-assemble` adds narrative responses
- Assessment results from C2P can be imported back: `trestle import -f assessment-results.json`

Trestle does NOT execute PVP checks — that is C2P's responsibility.

### Supported PVP Types

| PVP Type | Policy Style | Examples |
|----------|-------------|----------|
| Declarative | Desired-state manifests | Kubernetes (OCM, GateKeeper, Kyverno) |
| Imperative | Step-by-step scripts | Auditree (Python), Ansible playbooks |

- **Declarative PVPs**: C2P generates Kubernetes policy CRDs from component definitions
- **Imperative PVPs**: C2P generates configuration files (e.g., `auditree.json`) with parameters

### C2P Workflow Summary

```bash
# 1. Author component definitions with Trestle (rules + checks)
trestle task csv-to-oscal-cd

# 2. C2P generates PVP-specific configuration
#    (C2P reads component-definition.json, outputs PVP config)

# 3. PVP executes checks against target systems
#    (Auditree runs fetchers + checks, OCM distributes policies to clusters)

# 4. C2P collects results and produces OSCAL Assessment Results
#    (C2P reads PVP output, outputs assessment-results.json)

# 5. Import results back into Trestle workspace
trestle import -f assessment-results.json -o latest-scan
```

## Additional Resources

- [personas-reference.md](personas-reference.md) — Full persona details, CPAC topologies, C2P plugin interface, Auditree project structure
- [examples.md](examples.md) — Worked pipeline walkthroughs with complete command sequences

## Cross-References

- **trestle-authoring-workflow**: Generate/edit/assemble cycle details, multi-repo coordination
- **trestle-task-system**: `csv-to-oscal-cd` configuration, CSV column reference, dual component definition CSV pattern
- **trestle-control-implementation**: SSP control response writing, rules supply chain
- **trestle-oscal-models**: OSCAL model types, relationships, and persona ownership
