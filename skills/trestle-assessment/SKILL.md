---
name: trestle-assessment
description: >-
  Knowledge about OSCAL assessment plans and assessment results models in Compliance Trestle.
  Use when users ask about assessment plans, assessment results, security assessments, SAP,
  SAR, assessment activities, findings, observations, or assessment-related OSCAL models.
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
---

# OSCAL Assessment Models in Trestle

## Overview

OSCAL defines two assessment-related models:
- **Assessment Plan (SAP)**: Defines the scope, methodology, and schedule for a security assessment
- **Assessment Results (SAR)**: Documents the findings, observations, and risks from an assessment

## Assessment Plan (SAP)

### Purpose
Defines what will be assessed, how, when, and by whom. Corresponds to a Security Assessment Plan in FedRAMP/NIST terminology.

### Key Components

```json
{
  "assessment-plan": {
    "uuid": "...",
    "metadata": { "title": "...", "version": "..." },
    "import-ssp": { "href": "#..." },
    "local-definitions": {
      "activities": [],
      "objectives-and-methods": []
    },
    "reviewed-controls": {
      "control-selections": [
        { "include-controls": [{ "control-id": "ac-1" }] }
      ]
    },
    "assessment-subjects": [],
    "assessment-assets": {
      "assessment-platforms": []
    },
    "tasks": []
  }
}
```

### Key Fields

| Field | Purpose |
|-------|---------|
| `import-ssp` | References the SSP being assessed |
| `reviewed-controls` | Controls in scope for this assessment |
| `assessment-subjects` | Systems, components, or inventories being assessed |
| `assessment-assets` | Tools and platforms used for assessment |
| `tasks` | Scheduled assessment activities |
| `local-definitions.activities` | Assessment activities and their steps |
| `local-definitions.objectives-and-methods` | Assessment objectives tied to controls |

### Workspace Location
```
assessment-plans/
└── my-assessment/
    └── assessment-plan.json
```

## Assessment Results (SAR)

### Purpose
Documents the outcomes of a security assessment, including findings, observations, and risk determinations.

### Key Components

```json
{
  "assessment-results": {
    "uuid": "...",
    "metadata": { "title": "...", "version": "..." },
    "import-ap": { "href": "#..." },
    "results": [
      {
        "uuid": "...",
        "title": "Assessment Round 1",
        "start": "2024-01-15T00:00:00Z",
        "end": "2024-01-30T00:00:00Z",
        "reviewed-controls": {},
        "findings": [],
        "observations": [],
        "risks": []
      }
    ]
  }
}
```

### Key Fields

| Field | Purpose |
|-------|---------|
| `import-ap` | References the assessment plan |
| `results` | One or more assessment result sets |
| `results[].findings` | Individual assessment findings per control |
| `results[].observations` | Evidence and observations collected |
| `results[].risks` | Identified risks with severity |
| `results[].attestations` | Assessor attestation statements |

### Finding Structure
```json
{
  "uuid": "...",
  "title": "AC-1 Finding",
  "description": "...",
  "target": {
    "type": "objective-id",
    "target-id": "ac-1",
    "status": { "state": "not-satisfied" }
  },
  "related-observations": [{ "observation-uuid": "..." }],
  "related-risks": [{ "risk-uuid": "..." }]
}
```

### Finding States
| State | Meaning |
|-------|---------|
| `satisfied` | Control objective is met |
| `not-satisfied` | Control objective is not met (generates POA&M entry) |

### Workspace Location
```
assessment-results/
└── my-assessment-results/
    └── assessment-results.json
```

## Trestle Operations

### Import Assessment Models
```bash
trestle import -f assessment-plan.json -o my-assessment
trestle import -f assessment-results.json -o my-results
```

### Validate
```bash
trestle validate -t assessment-plan -n my-assessment
trestle validate -t assessment-results -n my-results
```

### Split and Merge
Assessment models support split/merge like other OSCAL models:
```bash
trestle split -t assessment-results -n my-results -e 'assessment-results.results'
trestle merge -t assessment-results -n my-results -e 'results'
```

## Relationship to Other Models

```
Catalog → Profile → SSP → Assessment Plan → Assessment Results → POA&M
```

- Assessment Plan references an SSP via `import-ssp`
- Assessment Results reference an Assessment Plan via `import-ap`
- Findings in Assessment Results feed into POA&M items
- Controls assessed are selected from the SSP's profile

## Important: JSON-Based Workflow

Assessment models do **not** have `trestle author` generate/assemble commands. Unlike catalogs, profiles, component definitions, and SSPs, assessment plans and assessment results use a **JSON-based workflow**:

```
create → split → edit JSON → merge → validate
```

Direct JSON editing via the split/merge cycle is the correct approach for these models.

## Additional Resources

- For worked examples and step-by-step walkthroughs, see [examples.md](examples.md)
