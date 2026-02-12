---
description: Describe the structure and contents of an OSCAL model
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<file> [element_path]"
---

Inspect and describe the structure of an OSCAL model file.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `file` (`-f`): Path to the model file
   - `element_path` (`-e`): Optional element path to probe deeper

3. Run the describe command:
   ```
   trestle describe -f <file> [-e '<element_path>']
   ```

4. The output shows:
   - Model type and class name
   - For each field: name, type, and value preview
   - For lists: number of items and item type
   - For strings: value up to 100 characters
   - For split files: type shows as `stripped.<Type>`

5. Present the output in a readable format.

6. Suggest follow-up actions:
   - Probe deeper with element paths (e.g., `catalog.groups.0.controls.3`)
   - Split large elements for editing
   - Note: wildcards (*) and commas are not supported in describe element paths
