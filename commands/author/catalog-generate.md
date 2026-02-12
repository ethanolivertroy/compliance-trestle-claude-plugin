---
description: Generate markdown from an OSCAL catalog for editing
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<catalog_name> <output_dir>"
---

Generate editable markdown files from an OSCAL catalog.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `catalog_name` (`--name`): Name of catalog in the workspace
   - `output_dir` (`--output`): Directory for markdown output
   - Optional: `--yaml` / `-y`: Path to YAML header file
   - Optional: `--overwrite-header-values`: Overwrite existing header values
   - Optional: `--force-overwrite`: Erase existing markdown before regenerating

3. Verify the catalog exists at `catalogs/<catalog_name>/catalog.json`.

4. Run:
   ```
   trestle author catalog-generate --name <catalog_name> --output <output_dir>
   ```

5. Show the generated markdown structure:
   - One `.md` file per control
   - Subdirectories for control groups
   - YAML header with `x-trestle-set-params` for parameters

6. Explain what can be edited:
   - Parameter values in the YAML header (`x-trestle-set-params`)
   - Control statement prose (add/modify items)
   - Control guidance
   - New items can be added to the statement

7. Suggest next steps: Edit markdown, then run `catalog-assemble` to create updated JSON.
