---
description: Assemble edited component markdown back into OSCAL JSON
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<markdown_dir> <output_compdef>"
---

Assemble edited component definition markdown into OSCAL JSON.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `markdown_dir` (`--markdown`): Markdown directory
   - `output_compdef` (`--output`): Name for assembled component definition
   - Optional: `--name`: Source component definition
   - Optional: `--version`, `--regenerate`

3. Run:
   ```
   trestle author component-assemble --markdown <markdown_dir> --output <output_compdef>
   ```

4. This assembles all component directories and their control markdown back into a single component-definition JSON.

5. Show output and suggest next steps.
