---
description: Assemble SSP markdown into an OSCAL System Security Plan JSON
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<markdown_dir> <output_ssp>"
---

Assemble edited SSP markdown into an OSCAL System Security Plan JSON file.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `markdown_dir` (`--markdown`): SSP markdown directory
   - `output_ssp` (`--output`): Name for assembled SSP
   - Optional: `--name`: Source SSP for metadata
   - Optional: `--version`, `--regenerate`

3. Run:
   ```
   trestle author ssp-assemble --markdown <markdown_dir> --output <output_ssp>
   ```

4. This creates an OSCAL SSP containing:
   - The resolved profile catalog
   - Implementation responses per component per control
   - Parameters and properties from component definitions
   - Implementation status per component

5. Won't write if content unchanged (prevents false CI/CD triggers).

6. Show output location and suggest next steps (validate, distribute, filter).
