---
description: Assemble edited catalog markdown back into OSCAL JSON
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<markdown_dir> <output_catalog>"
---

Assemble edited catalog markdown files into an OSCAL JSON catalog.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `markdown_dir` (`--markdown`): Directory containing edited markdown
   - `output_catalog` (`--output`): Name for the assembled catalog
   - Optional: `--name`: Source catalog for metadata (used on first assembly)
   - Optional: `--set-parameters`: Apply parameter changes from YAML headers
   - Optional: `--version`: Set version string
   - Optional: `--regenerate`: Generate new UUIDs

3. Run:
   ```
   trestle author catalog-assemble --markdown <markdown_dir> --output <output_catalog> [--set-parameters] [--version <ver>]
   ```

4. On first assembly, use `--name <original_catalog>` to inherit metadata from the source.

5. Note: The assembled file won't be written if content is unchanged (prevents CI/CD false triggers).

6. Show the output location and suggest next steps.
