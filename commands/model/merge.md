---
description: Merge split OSCAL sub-components back into their parent file
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<element_path>"
---

Merge split OSCAL sub-component files back into their parent file.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `element_path` (`-e`): The element path to merge (must have at least 2 elements)
   - Use `.*` to merge all sub-components: `catalog.*`

3. Navigate to the correct directory (merge is relative to current working directory).

4. Run the merge command:
   ```
   trestle merge -e '<element_path>'
   ```

5. This recursively merges any split sub-components before merging the target.

6. Show the resulting file structure after merging.

7. Note: The merge command is the reverse of split. It combines files from subdirectories back into the parent JSON/YAML file.
