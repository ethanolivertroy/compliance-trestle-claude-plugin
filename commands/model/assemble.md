---
description: Assemble a split OSCAL model into a single file in dist/
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<type> <name>"
---

Assemble all split parts of an OSCAL model into a single file in the dist/ directory.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `type`: The model type (catalog, profile, etc.)
   - `name`: The model name

3. Run the assemble command:
   ```
   trestle assemble <type> -n <name>
   ```

4. This will traverse the model directory and combine all split files into a single OSCAL file at `dist/<type_plural>/<name>.json`.

5. On success, show:
   - The output file location
   - Note that assembly also validates the content

6. On failure, explain the error and suggest fixes.

Note: This is the basic `trestle assemble` for recombining split files. For author workflow assembly (markdown to JSON), use the author-specific assemble commands like `/trestle-catalog-assemble` or `/trestle-ssp-assemble`.
