---
description: Validate a specific OSCAL element within a file
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<file> <element>"
---

Validate a specific OSCAL element within a file without validating the entire model.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `file` (`-f` / `--file`): Path to the file containing the element
   - `element` (`-e` / `--element`): Element path to validate (e.g., `catalog.metadata`)
   - `--no-validators` / `-nv` (optional): Only perform basic schema validation, skip additional validators

3. Explain when partial validation is useful:
   - After splitting a model, to validate individual sub-components
   - To check a specific section without full model assembly
   - For quick validation during iterative editing
   - When full validation is too slow or reports unrelated issues

4. Run the partial validation:
   ```
   trestle partial-object-validate -f <file> -e <element>
   ```

5. Report results:
   - If valid: confirm the element passes OSCAL schema validation
   - If invalid: show the specific validation errors and their locations
   - Suggest fixes for common validation issues

6. Note the difference from full validation (`trestle validate`):
   - `trestle validate` runs all validators (duplicates, refs, links, catalog rules, rule-parameters)
   - `partial-object-validate` validates a single element against the OSCAL schema
   - Use `-nv` to skip even the additional validators and do schema-only checking
