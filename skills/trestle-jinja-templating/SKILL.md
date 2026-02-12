---
name: trestle-jinja-templating
description: >-
  Knowledge about Compliance Trestle's Jinja2 templating system for generating compliance documents.
  Use when users ask about Jinja templates, document generation from OSCAL data, custom trestle Jinja
  tags (mdsection_include, md_clean_include, md_datestamp), custom filters (as_list, get_party,
  parties_for_role, diagram_href), SSP document rendering, lookup tables, or bracket formatting.
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
---

# Trestle Jinja Templating

Trestle provides a Jinja2-based templating system (`trestle author jinja`) for generating compliance documents from OSCAL data. Templates can reference SSPs, profiles, and catalogs to produce formatted markdown or other document formats.

## Command Usage

```bash
trestle author jinja -i <template_path> -o <output_path> [options]
```

## Custom Jinja Tags

Trestle extends Jinja2 with three custom tags:

### mdsection_include

Include a specific section from a markdown file by heading title:

```jinja
{% mdsection_include "path/to/file.md" "Section Title" heading_level=2 %}
```

- `heading_level` controls which heading level to search for (default: based on document structure)
- Extracts the section and all content until the next heading of equal or higher level

### md_clean_include

Include an entire markdown file, stripping YAML frontmatter:

```jinja
{% md_clean_include "path/to/file.md" heading_level=2 %}
```

- Removes YAML frontmatter (between `---` markers)
- Adjusts heading levels relative to `heading_level`
- Useful for composing documents from multiple markdown sources

### md_datestamp

Insert a formatted date stamp:

```jinja
{% md_datestamp format="%Y-%m-%d" newline=True %}
```

- `format` follows Python strftime format strings
- `newline` adds a trailing newline (default: `True`)

## Custom Jinja Filters

| Filter | Description | Example |
|--------|-------------|---------|
| `as_list` | Convert value to a list | `{{ value \| as_list }}` |
| `get_default` | Get the default value | `{{ param \| get_default }}` |
| `first_or_none` | Get first element or None | `{{ items \| first_or_none }}` |
| `get_party` | Get party by UUID from SSP | `{{ ssp \| get_party(uuid) }}` |
| `parties_for_role` | Get all parties for a role ID | `{{ ssp \| parties_for_role(role_id) }}` |
| `diagram_href` | Get diagram link href | `{{ diagram \| diagram_href }}` |

## Context Objects

When an SSP is provided (`--ssp`), these objects are available in templates:

| Variable | Type | Description |
|----------|------|-------------|
| `ssp` | SystemSecurityPlan | The full SSP object |
| `catalog` | Catalog | Resolved catalog from the SSP's profile |
| `catalog_interface` | CatalogInterface | Utility for querying catalog controls |
| `control_interface` | ControlInterface | Utility for working with individual controls |
| `control_writer` | DocsControlWriter | Writer for formatting control documentation |
| `ssp_md_writer` | SSPMarkdownWriter | Writer for SSP markdown output |

When `--docs-profile` is used for per-control output:

| Variable | Type | Description |
|----------|------|-------------|
| `profile` | Profile | The profile being processed |
| `control` | Control | Current control being rendered |
| `group_title` | str | Title of the control's group |

## Lookup Tables

Provide additional variables via a YAML lookup table (`-lut`):

```yaml
# lookup.yaml
system_name: My Federal System
authorization_date: 2024-01-15
fips_level: Moderate
```

```jinja
# In template
System Name: {{ system_name }}
Authorization Date: {{ authorization_date }}
```

## Bracket Formatting

The `-bf` / `--bracket-format` flag controls how parameter values appear:

| Format | Example Output |
|--------|---------------|
| `[.]` | `[value]` |
| `((.))` | `((value))` |
| None | `value` (no brackets) |

Use `-vap` and `-vnap` to prefix values based on assignment status:
- `-vap "Assigned: "` — prefix when parameter has a value
- `-vnap "MISSING: "` — prefix when parameter has no value

## Example Templates

### SSP Front Matter Template

```jinja
---
title: System Security Plan
date: {% md_datestamp format="%B %d, %Y" %}
---

# {{ ssp.system_characteristics.system_name }}

## System Description
{{ ssp.system_characteristics.description }}

## Authorization Boundary
{% mdsection_include "boundary.md" "Authorization Boundary" heading_level=2 %}

## Leveraged Services
{% for leveraged in ssp.system_implementation.leveraged_authorizations %}
- {{ leveraged.title }}
{% endfor %}
```

### Control Documentation Template

```jinja
# Control: {{ control.id }}

{% for part in control.parts %}
## {{ part.name }}
{{ part.prose }}
{% endfor %}

### Responsible Parties
{% for role in control.responsible_roles %}
- {{ role.role_id }}: {% for party_uuid in role.party_uuids %}{{ ssp | get_party(party_uuid) }}{% endfor %}
{% endfor %}
```

## Assessment and POA&M Report Templates

Assessment data is not directly available as Jinja context objects (unlike SSPs). To use assessment and POA&M data in Jinja templates, pre-extract the data into YAML lookup tables and pass them via `-lut`.

### Assessment Report Template

Prepare a lookup table with extracted assessment data:

```yaml
# assessment-lookup.yaml
assessment_title: "Annual Security Assessment 2024"
assessment_date: "2024-02-28"
assessor: "Security Assessment Team"
total_controls: 45
satisfied_count: 38
not_satisfied_count: 5
other_count: 2

findings:
  - control_id: "AC-1"
    title: "Outdated Access Control Policy"
    status: "not-satisfied"
    risk_level: "High"
    observation: "Policy last updated 3 years ago"
  - control_id: "AC-2"
    title: "Account Management"
    status: "satisfied"
    risk_level: "N/A"
    observation: "Account management procedures verified"
  - control_id: "SC-7"
    title: "Boundary Protection"
    status: "satisfied"
    risk_level: "N/A"
    observation: "Network boundary controls verified via scan"
```

Template for an assessment report:

```jinja
---
title: {{ assessment_title }}
date: {% md_datestamp format="%B %d, %Y" %}
---

# Assessment Report: {{ assessment_title }}

**Assessment Date:** {{ assessment_date }}
**Assessor:** {{ assessor }}

## Summary

| Metric | Count |
|--------|-------|
| Total Controls Assessed | {{ total_controls }} |
| Satisfied | {{ satisfied_count }} |
| Not Satisfied | {{ not_satisfied_count }} |
| Other | {{ other_count }} |

## Findings Summary

| Control | Title | Status | Risk Level |
|---------|-------|--------|------------|
{% for finding in findings -%}
| {{ finding.control_id }} | {{ finding.title }} | {{ finding.status }} | {{ finding.risk_level }} |
{% endfor %}

## Detailed Findings

{% for finding in findings %}
{% if finding.status == "not-satisfied" %}
### {{ finding.control_id }}: {{ finding.title }}

**Status:** {{ finding.status }}
**Risk Level:** {{ finding.risk_level }}
**Observation:** {{ finding.observation }}

{% endif %}
{% endfor %}
```

Run with:
```bash
trestle author jinja -i assessment-report.md.j2 -o assessment-report.md -lut assessment-lookup.yaml
```

### POA&M Status Report Template

Prepare a lookup table with POA&M data:

```yaml
# poam-lookup.yaml
system_name: "My Federal System"
report_date: "2024-03-15"
total_items: 5
open_items: 3
closed_items: 1
deviation_items: 1

risk_breakdown:
  high: 2
  moderate: 2
  low: 1

poam_items:
  - id: "POAM-001"
    control: "AC-1"
    title: "Outdated Access Control Policy"
    risk_level: "High"
    status: "remediating"
    due_date: "2024-03-31"
    milestones:
      - title: "Draft updated policy"
        due: "2024-03-15"
        status: "complete"
      - title: "Policy approved"
        due: "2024-03-31"
        status: "in-progress"
  - id: "POAM-002"
    control: "AU-2"
    title: "Incomplete Audit Logging"
    risk_level: "High"
    status: "open"
    due_date: "2024-08-31"
    milestones:
      - title: "Phase 1: Core logging"
        due: "2024-04-30"
        status: "pending"
```

Template for a POA&M status report:

```jinja
---
title: POA&M Status Report - {{ system_name }}
date: {% md_datestamp format="%B %d, %Y" %}
---

# POA&M Status Report

**System:** {{ system_name }}
**Report Date:** {{ report_date }}

## Summary

| Status | Count |
|--------|-------|
| Open | {{ open_items }} |
| Closed | {{ closed_items }} |
| Deviation/Accepted | {{ deviation_items }} |
| **Total** | **{{ total_items }}** |

## Risk Breakdown

| Risk Level | Count |
|------------|-------|
| High | {{ risk_breakdown.high }} |
| Moderate | {{ risk_breakdown.moderate }} |
| Low | {{ risk_breakdown.low }} |

## Open Items

| ID | Control | Title | Risk | Status | Due Date |
|----|---------|-------|------|--------|----------|
{% for item in poam_items -%}
{% if item.status != "closed" -%}
| {{ item.id }} | {{ item.control }} | {{ item.title }} | {{ item.risk_level }} | {{ item.status }} | {{ item.due_date }} |
{% endif -%}
{% endfor %}

## Milestone Timeline

{% for item in poam_items %}
{% if item.status != "closed" %}
### {{ item.id }}: {{ item.control }} - {{ item.title }}

| Milestone | Due Date | Status |
|-----------|----------|--------|
{% for ms in item.milestones -%}
| {{ ms.title }} | {{ ms.due }} | {{ ms.status }} |
{% endfor %}

{% endif %}
{% endfor %}
```

Run with:
```bash
trestle author jinja -i poam-report.md.j2 -o poam-report.md -lut poam-lookup.yaml
```
