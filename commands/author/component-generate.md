---
description: Generate markdown from an OSCAL component definition
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<compdef_name> <output_dir>"
---

Generate editable markdown from an OSCAL component definition.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `compdef_name` (`--name`): Component definition name
   - `output_dir` (`--output`): Markdown output directory
   - Optional: `--yaml`, `--overwrite-header-values`, `--force-overwrite`

3. Run:
   ```
   trestle author component-generate --name <compdef_name> --output <output_dir>
   ```

4. Show the generated structure:
   - Separate directories per component
   - One markdown file per control within each component directory
   - YAML headers with rules, parameters, and implementation details

5. Explain what can be edited:
   - Implementation prose per control per component
   - Parameter values (component-values)
   - Implementation status
   - Rules are read-only (come from the component definition)

6. Next steps: Edit markdown, then `component-assemble`.
