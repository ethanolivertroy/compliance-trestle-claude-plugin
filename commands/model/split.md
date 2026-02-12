---
description: Split an OSCAL model into smaller sub-component files
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<file> <element_path>"
---

Split an OSCAL model file into smaller sub-component files for easier editing.

## Steps

1. Verify we are in a trestle workspace and navigate to the model directory.

2. Parse $ARGUMENTS for:
   - `file` (`-f`): The JSON/YAML file to split
   - `element_path` (`-e`): The element path(s) to split out (comma-separated)

3. Explain element path syntax:
   - Use dot notation: `catalog.metadata`, `catalog.groups`
   - Use `.*` suffix to split array items into individual files: `catalog.groups.*`
   - Without `.*`, arrays go into a single file: `catalog.groups`
   - Quote paths containing `*` on Unix shells

4. Run the split command:
   ```
   trestle split -f <file> -e '<element_path>'
   ```

5. Show the resulting directory structure after splitting.

6. Explain:
   - How split files can be edited independently
   - Use `trestle merge` to recombine
   - Use `trestle describe` to inspect split files
