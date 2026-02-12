---
name: trestle-governance
description: >-
  Knowledge about Compliance Trestle's document governance system for enforcing consistent
  document structure and YAML headers. Use when users ask about document governance, header
  enforcement, template validation, governed headings, governed folders, trestle author docs/headers/folders,
  template setup, document structure enforcement, or CI/CD compliance document validation.
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
---

# Trestle Document Governance

Trestle provides three governance commands that enforce consistent structure across compliance documentation using templates. This enables teams to maintain standardized document formats and integrate structure validation into CI/CD pipelines.

## Three Governance Commands

| Command | Scope | What It Enforces |
|---------|-------|-----------------|
| `trestle author headers` | YAML frontmatter only | Header field names, types, and required values |
| `trestle author docs` | Full markdown documents | Headers + document structure (headings, sections) |
| `trestle author folders` | Directory structure | Headers + docs + folder layout (same files in each instance) |

## Four Modes

Each governance command supports four modes:

| Mode | Purpose | Example |
|------|---------|---------|
| `setup` | Create template directory and initial templates | `trestle author docs setup -tn my-task` |
| `create-sample` | Generate new instances from templates | `trestle author docs create-sample -tn my-task` |
| `template-validate` | Validate the template files themselves | `trestle author docs template-validate -tn my-task` |
| `validate` | Validate instance documents against templates | `trestle author docs validate -tn my-task` |

## Template Location

Templates are stored in the trestle workspace under:

```
.trestle/author/<task-name>/
├── template.md           # For docs governance
├── a_template.md         # For folders governance
├── another_template.md   # Additional folder templates
└── architecture.drawio   # Non-markdown templates
```

Instance documents live at the workspace root:

```
<task-name>/
├── document_001.md       # Created by create-sample
├── document_002.md
└── subfolder/            # For folders governance
    ├── a_template.md
    └── another_template.md
```

## Template Versioning

Templates use `x-trestle-template-version` in their YAML header to track versions:

```yaml
---
x-trestle-template-version: 1.0.0
title: ""
description: ""
status: draft
---
```

When `--template-version` is specified during validation, only documents matching that template version are checked. This enables gradual template migration.

## Governed Headings

The `-gh` / `--governed-heading` flag enforces that specific markdown headings exist in documents:

```bash
trestle author docs validate -tn my-task -gh "Purpose" -gh "Scope"
```

This ensures every document under `my-task/` contains `## Purpose` and `## Scope` sections.

## Key Flags

| Flag | Commands | Description |
|------|----------|-------------|
| `-tn, --task-name` | All | Task name (maps to directory names) |
| `-gh, --governed-heading` | docs, folders | Required heading in documents |
| `-hv, --header-validate` | docs, folders | Validate YAML header structure |
| `-hov, --header-only-validate` | docs, folders | Only validate headers, skip body |
| `-r, --recurse` | headers, docs | Recurse into subdirectories |
| `-rv, --readme-validate` | All | Include README.md in validation |
| `-tv, --template-version` | All | Target specific template version |
| `-ig, --ignore` | All | Regex to ignore files/folders |
| `-g, --global` | headers | Use global template at `__global__/` |
| `-vtt, --validate-template-type` | docs, folders | Use `x-trestle-template-type` field |

## CI/CD Integration

Governance commands are designed for CI/CD pipelines. Common patterns:

### GitHub Actions

```yaml
- name: Validate compliance docs
  run: |
    trestle author docs validate -tn policies -hv -gh "Purpose" -gh "Scope"
    trestle author headers validate -tn standards -r
```

### Pre-commit Hook

```yaml
- repo: local
  hooks:
    - id: trestle-docs-validate
      name: Validate governed docs
      entry: trestle author docs validate -tn my-task -hv
      language: system
      pass_filenames: false
```

## Workflow: Setting Up Governance

1. **Create templates**:
   ```bash
   trestle author docs setup -tn security-policies
   ```

2. **Customize the template** at `.trestle/author/security-policies/template.md`:
   - Add required YAML header fields
   - Add governed heading structure
   - Set `x-trestle-template-version`

3. **Generate samples**:
   ```bash
   trestle author docs create-sample -tn security-policies
   ```

4. **Validate**:
   ```bash
   trestle author docs validate -tn security-policies -hv -gh "Purpose"
   ```

5. **Add to CI/CD** to enforce going forward.

## Headers vs Docs vs Folders

Choose the right governance level:

- **headers**: Lightweight — just enforce consistent YAML frontmatter across documents. Good for metadata standardization.
- **docs**: Medium — enforce both headers and document structure (headings). Good for policy documents, procedures, runbooks.
- **folders**: Heavy — enforce entire directory structures. Good for system assessment packages, component evidence folders, or any case where multiple related files must exist together.

## Practical Template Example: Security Policy

### Template File

Located at `.trestle/author/security-policies/template.md`:

```markdown
---
x-trestle-template-version: 1.0.0
title: ""
status: draft
owner: ""
review-date: ""
---

# [Policy Title]

## Purpose

[Describe why this policy exists and what it aims to achieve.]

## Scope

[Describe who and what this policy applies to.]

## Policy Statement

[The actual policy requirements and mandates.]

## Enforcement

[Describe consequences for non-compliance and how the policy is enforced.]

## Exceptions

[Process for requesting exceptions and who approves them.]
```

### Instance Document

An actual policy at `security-policies/access-control-policy.md`:

```markdown
---
x-trestle-template-version: 1.0.0
title: Access Control Policy
status: approved
owner: Chief Information Security Officer
review-date: 2025-06-15
---

# Access Control Policy

## Purpose

This policy establishes requirements for managing access to organizational
information systems to ensure only authorized users can access sensitive
resources.

## Scope

This policy applies to all employees, contractors, and third-party users
who access organizational information systems.

## Policy Statement

All access to information systems must follow the principle of least
privilege. Users shall be granted only the minimum access necessary to
perform their job functions. Privileged access requires additional approval
from the system owner and ISSO.

## Enforcement

Violations are handled through the organizational disciplinary process.
Automated monitoring detects unauthorized access attempts and triggers
incident response procedures.

## Exceptions

Exception requests must be submitted to the ISSO with business justification.
Exceptions are reviewed quarterly and expire after 12 months unless renewed.
```

### Validate the Structure

```bash
trestle author docs validate -tn security-policies -hv \
  -gh "Purpose" -gh "Scope" -gh "Policy Statement" \
  -gh "Enforcement" -gh "Exceptions"
```

## Using Global Templates

Global templates apply organization-wide header standards across all task names.

**Location**: `.trestle/author/__global__/`

```
.trestle/author/
├── __global__/
│   └── template.md          # Global header template
├── security-policies/
│   └── template.md          # Task-specific template (extends global)
└── procedures/
    └── template.md
```

### How Global Templates Work

1. The global template defines **baseline YAML header fields** that every document must have (e.g., `status`, `owner`, `review-date`)
2. Task-specific templates can add **additional fields** on top of the global requirements
3. Validate against the global template with the `-g` flag:
   ```bash
   trestle author headers validate -tn security-policies -g
   ```
4. Global + task-specific validation runs both checks:
   ```bash
   trestle author headers validate -tn security-policies -g
   trestle author docs validate -tn security-policies -hv -gh "Purpose"
   ```

This lets you enforce organization-wide metadata standards while allowing each document type to have its own structural requirements.

## Template Migration

When templates evolve (e.g., adding a new required heading or header field), use template versioning for a smooth transition.

### Migration Steps

1. **Update the template** with the new requirements and bump the version:
   ```yaml
   ---
   x-trestle-template-version: 2.0.0    # was 1.0.0
   title: ""
   status: draft
   owner: ""
   review-date: ""
   risk-level: ""                        # new required field
   ---
   ```

2. **Add the new governed heading** (if applicable):
   ```markdown
   ## Risk Assessment
   [New required section for v2.0.0]
   ```

3. **Validate old documents against the old version** (no breakage):
   ```bash
   trestle author docs validate -tn security-policies -hv --template-version 1.0.0
   ```

4. **Migrate documents incrementally** — update each document to v2.0.0 format by adding the new field and section, then change its `x-trestle-template-version` to `2.0.0`.

5. **Validate migrated documents against the new version**:
   ```bash
   trestle author docs validate -tn security-policies -hv --template-version 2.0.0
   ```

6. **Drop the old version** once all documents are migrated — remove the `--template-version` flag to validate all documents against the current template.

## Governed Folder Example: Assessment Package

Governed folders ensure every instance of a folder-based document package has the same structure.

### Template Structure

```
.trestle/author/assessment-evidence/
├── overview.md
├── test-results.md
└── screenshots/
    └── placeholder.md
```

### Instance Folders

Each assessment creates a folder matching this structure:

```
assessment-evidence/
├── 2024-q1-assessment/
│   ├── overview.md
│   ├── test-results.md
│   └── screenshots/
│       └── placeholder.md
├── 2024-q3-assessment/
│   ├── overview.md
│   ├── test-results.md
│   └── screenshots/
│       └── placeholder.md
```

### Setup and Validation

```bash
# Set up the governed folder template
trestle author folders setup -tn assessment-evidence

# Create a new instance from the template
trestle author folders create-sample -tn assessment-evidence -on 2025-q1-assessment

# Validate all instances have the required structure
trestle author folders validate -tn assessment-evidence -hv
```

Validation checks that each instance folder contains all the files present in the template folder, and that those files conform to their template's headers and governed headings.

## Cross-References

- **trestle-control-implementation**: SSP control markdown follows trestle-governed header conventions for parameters and rules
- **trestle-validation**: Combine governance structure validation with OSCAL schema validation for full coverage
- **trestle-authoring-workflow**: Integrating governance validation into the generate/assemble CI/CD pipeline
