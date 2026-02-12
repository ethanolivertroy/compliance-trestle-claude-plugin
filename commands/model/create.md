---
description: Create a new OSCAL model in the workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<type> <name> [--include-optional-fields]"
---

Create a new bare-bones OSCAL model in the Trestle workspace.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `type`: One of catalog, profile, component-definition, system-security-plan, assessment-plan, assessment-results, plan-of-action-and-milestones
   - `name`: The name/alias for the model
   - Optional `--include-optional-fields` or `-iof`: Include optional OSCAL fields

3. Run the create command:
   ```
   trestle create -t <type> -o <name> [-iof]
   ```

4. Verify the model was created by checking the appropriate directory.

5. Show the user the created file structure and explain:
   - The model file location (e.g., `catalogs/<name>/catalog.json`)
   - That `REPLACE_ME` placeholders need to be filled in
   - How to edit the model (split for large edits, or direct JSON editing)
   - Next steps: import content, use author commands, or edit directly
