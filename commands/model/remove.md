---
description: Remove a subcomponent from an OSCAL model
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<file> <element_path>"
---

Remove a subcomponent (element) from an OSCAL model file.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `file` (`-f`): The JSON/YAML file to modify
   - `element_path` (`-e`): The element path to remove

3. Explain element path syntax:
   - Use dot notation: `catalog.metadata`, `catalog.back-matter`
   - Removes the specified element and its children from the parent model
   - Does not support removing individual items from a list — removes the entire list/dict
   - Does not support wildcard element paths

4. Show the current state of the element before removal:
   ```
   trestle describe -f <file> -e <element_path>
   ```

5. Run the remove command:
   ```
   trestle remove -f <file> -e <element_path>
   ```

6. Confirm the element was removed and show the updated model structure.

7. Note: This is the inverse of `trestle add`. The file is modified in-place.
