---
description: Validate OSCAL models in the Trestle workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "[--all | --type <type> | --name <name>]"
---

Validate OSCAL models in the Compliance Trestle workspace.

## Steps

1. Verify we are in a trestle workspace (check for `.trestle/` directory).

2. Determine validation scope from $ARGUMENTS:
   - No arguments or `--all`: Validate all models with `trestle validate -a`
   - `--type <type>`: Validate all models of a type with `trestle validate -t <type>`
   - `--name <name> --type <type>`: Validate specific model with `trestle validate -t <type> -n <name>`
   - A file path: Validate specific file with `trestle validate -f <path>`

3. Run the validation command and capture output.

4. Parse the results:
   - Report which models passed validation
   - Report any validation errors with details
   - Trestle runs these built-in validators (registered in `ValidatorFactory`):
     - **duplicates** — Checks for duplicate UUIDs across the model
     - **refs** — Validates that internal references resolve correctly
     - **links** — Validates that link hrefs are reachable
     - **catalog** — Catalog-specific structural rules
     - **rules** (rule-parameters) — Validates rule parameter consistency in component definitions
     - **all** — Runs all of the above validators together

5. If validation fails, suggest corrective actions based on the error type.

6. For validating a single element within a file (e.g., after splitting), mention `trestle partial-object-validate -f <file> -e <element>` as a targeted alternative.

7. Present a summary: total models checked, passed, failed.
