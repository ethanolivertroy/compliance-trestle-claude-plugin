---
description: Full component definition authoring workflow
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<compdef_name>"
---

Execute the full component definition authoring roundtrip workflow.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for the component definition name. If not provided, list available component-definitions.

3. **Generate Phase**:
   ```
   trestle author component-generate --name <compdef_name> --output <compdef_name>-markdown
   ```

4. Show the structure:
   - Separate directories per component
   - One markdown file per control within each component
   - Rules and parameters in YAML header
   - Implementation prose sections

5. **Edit Phase**: Guide the user:
   - Show a sample control for one component
   - Explain rules (read-only, from JSON)
   - Explain how to add implementation prose
   - Set component-values for rule parameters
   - Set implementation status

6. **Assemble Phase**:
   ```
   trestle author component-assemble --markdown <compdef_name>-markdown --output <compdef_name>
   ```

7. Validate and report results.

8. Suggest: The component definition can now be used with `ssp-generate --compdefs` to create SSPs.
