---
description: Show trestle and OSCAL version information
allowed-tools: Bash, Read
user-invocable: true
argument-hint: "[--name <model> --type <type>]"
---

Show version information for trestle, OSCAL, and optionally a specific model.

## Steps

1. Show the trestle and OSCAL version:
   ```
   trestle version
   ```
   This outputs: `Trestle version v<X.Y.Z> based on OSCAL version <A.B.C>`

2. If $ARGUMENTS includes a model name and type, also show the OSCAL version of that specific model:
   ```
   trestle version -n <model_name> -t <model_type>
   ```
   Where `model_type` is one of: `catalog`, `profile`, `component-definition`, `ssp`, `assessment-plan`, `assessment-results`, `poam`

3. Present the version information clearly, noting:
   - The trestle library version
   - The OSCAL schema version trestle was built against
   - The OSCAL version of the specified model (if requested) — useful for checking compatibility
