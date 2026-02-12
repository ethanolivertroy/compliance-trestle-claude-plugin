---
name: trestle-poam
description: >-
  Knowledge about the OSCAL Plan of Action and Milestones (POA&M) model in Compliance Trestle.
  Use when users ask about POA&M, plan of action, milestones, remediation, findings tracking,
  risk management, or managing security finding remediation workflows.
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
---

# OSCAL Plan of Action and Milestones (POA&M) in Trestle

## Overview

The POA&M model tracks security findings that need remediation. It documents:
- What weaknesses were found
- What risks they pose
- What actions will be taken to remediate them
- When remediation milestones are expected to be completed

## POA&M Structure

```json
{
  "plan-of-action-and-milestones": {
    "uuid": "...",
    "metadata": {
      "title": "System POA&M",
      "version": "1.0"
    },
    "import-ssp": { "href": "#..." },
    "system-id": { "id": "..." },
    "poam-items": [
      {
        "uuid": "...",
        "title": "AC-1 Finding",
        "description": "Access control policy not fully documented",
        "related-observations": [],
        "related-risks": [],
        "origins": [],
        "remarks": "..."
      }
    ],
    "local-definitions": {
      "components": [],
      "inventory-items": []
    },
    "observations": [],
    "risks": []
  }
}
```

## Key Components

### POA&M Items

Each POA&M item represents a finding requiring remediation:

| Field | Purpose |
|-------|---------|
| `title` | Short description of the finding |
| `description` | Detailed description of the weakness |
| `related-observations` | Links to observations from assessment |
| `related-risks` | Links to associated risk entries |
| `origins` | Who/what identified this item |
| `remarks` | Additional notes or context |

### Observations

Observations provide evidence and context for findings:

```json
{
  "uuid": "...",
  "title": "AC-1 Observation",
  "description": "Policy document was last updated 3 years ago",
  "methods": ["EXAMINE", "INTERVIEW"],
  "types": ["finding"],
  "subjects": [{ "subject-uuid": "...", "type": "component" }],
  "collected": "2024-01-15T00:00:00Z"
}
```

### Assessment Methods
| Method | Description |
|--------|-------------|
| `EXAMINE` | Review of documentation, records, configurations |
| `INTERVIEW` | Discussion with personnel |
| `TEST` | Hands-on testing of systems and controls |

### Risks

Risk entries document the risk associated with findings:

```json
{
  "uuid": "...",
  "title": "Outdated Access Control Policy",
  "description": "...",
  "statement": "Without current policy, access controls may not meet requirements",
  "status": "open",
  "characterizations": [
    {
      "origin": {},
      "facets": [
        { "name": "likelihood", "value": "moderate", "system": "..." },
        { "name": "impact", "value": "high", "system": "..." }
      ]
    }
  ],
  "mitigating-factors": [],
  "remediations": [
    {
      "uuid": "...",
      "lifecycle": "planned",
      "title": "Update access control policy",
      "description": "...",
      "required-assets": [],
      "tasks": [
        {
          "uuid": "...",
          "type": "milestone",
          "title": "Draft updated policy",
          "timing": {
            "within-date-range": {
              "start": "2024-02-01",
              "end": "2024-03-01"
            }
          }
        }
      ]
    }
  ]
}
```

### Risk Status Values
| Status | Meaning |
|--------|---------|
| `open` | Finding is active, not yet remediated |
| `investigating` | Under investigation |
| `remediating` | Actively being remediated |
| `deviation-requested` | Requesting deviation/risk acceptance |
| `deviation-approved` | Deviation approved (risk accepted) |
| `closed` | Finding has been remediated and verified |

### Remediation Lifecycle
| Lifecycle | Meaning |
|-----------|---------|
| `recommendation` | Suggested action |
| `planned` | Approved remediation plan |
| `completed` | Remediation action completed |

## Workspace Location

```
plan-of-action-and-milestones/
└── my-system-poam/
    └── plan-of-action-and-milestones.json
```

## Trestle Operations

### Import
```bash
trestle import -f poam.json -o my-system-poam
```

### Validate
```bash
trestle validate -t plan-of-action-and-milestones -n my-system-poam
```

### Split and Merge
```bash
trestle split -t plan-of-action-and-milestones -n my-system-poam -e 'plan-of-action-and-milestones.poam-items'
trestle merge -t plan-of-action-and-milestones -n my-system-poam -e 'poam-items'
```

## Relationship to Other Models

```
Assessment Results → POA&M
       ↑                ↓
      SSP          Remediation Tracking
```

- POA&M references an SSP via `import-ssp`
- POA&M items typically originate from Assessment Results findings
- Each `not-satisfied` finding in Assessment Results should have a corresponding POA&M item
- Milestones track the remediation progress over time

## Common Workflows

1. **Create from Assessment**: Extract findings from Assessment Results into POA&M items
2. **Track Remediation**: Update risk status and add milestones as work progresses
3. **Close Findings**: Mark risks as `closed` when remediated and verified
4. **Report**: Generate POA&M reports showing open items, progress, and timelines

## Important: JSON-Based Workflow

The POA&M model does **not** have `trestle author` generate/assemble commands. Unlike catalogs, profiles, component definitions, and SSPs, POA&M uses a **JSON-based workflow**:

```
create → split → edit JSON → merge → validate
```

Direct JSON editing via the split/merge cycle is the correct approach for POA&M.

## Additional Resources

- For worked examples and step-by-step walkthroughs, see [examples.md](examples.md)
