---
description: Import an existing OSCAL document into the workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<file_path_or_url> <name>"
---

Import an existing OSCAL document into the Trestle workspace.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `file`: Path to the OSCAL file (absolute, relative, or URL). Supported protocols: file:///, https://, sftp://
   - `name`: The name/alias for the imported model

3. Verify the source file exists (if local path) and has a valid extension (.json, .yaml, .yml).

4. Run the import command:
   ```
   trestle import -f <file> -o <name>
   ```

5. The import will auto-detect the model type and validate the file.

6. If import fails, explain the error:
   - Validation failure: describe what's wrong with the OSCAL document
   - File not found: check the path
   - File inside trestle dir: must import from outside the workspace

7. On success, show where the model was imported and suggest next steps:
   - Use `trestle describe` to explore the model
   - Use `trestle split` to decompose for editing
   - Use author commands (catalog-generate, profile-generate, etc.) for markdown authoring

8. **If the imported model is a profile**, warn the user about import resolution:
   - Read the profile JSON and check `profile.imports[].href`
   - If any import uses `trestle://catalogs/<name>/...`, verify that catalog exists in the workspace
   - If it doesn't, tell the user they need to either import the referenced catalog or update the href with `trestle href`
   - This is critical — author commands (profile-generate) will fail if imports don't resolve
