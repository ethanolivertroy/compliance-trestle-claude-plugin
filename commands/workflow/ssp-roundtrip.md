---
description: Full SSP authoring workflow - generate, edit, and assemble
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<profile_name> [--compdefs comp1,comp2]"
---

Execute the full System Security Plan authoring roundtrip workflow.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name`: The profile defining the control baseline
   - Optional `--compdefs`: Comma-separated component definition names

3. **Pre-check**:
   - Verify profile exists and its imports resolve
   - If compdefs specified, verify they exist in `component-definitions/`
   - List the controls that will be included

4. **Generate Phase**:
   ```
   trestle author ssp-generate --profile <profile_name> --output ssp-markdown [--compdefs <comps>]
   ```

5. Show the structure and explain:
   - One file per control with implementation sections
   - "This System" component for overall system responses
   - Named components from component definitions (if provided)
   - Each statement part needs a response per component
   - Implementation status must be set per component

6. **Edit Phase**: Guide the user through writing implementation responses:
   - Show a sample control markdown
   - Explain the `<!-- Add control implementation description here -->` placeholders
   - Explain implementation status options: implemented, partial, planned, alternative, not-applicable
   - Explain parameter handling (ssp-values)
   - Help the user write responses for key controls if requested

7. **Assemble Phase**:
   ```
   trestle author ssp-assemble --markdown ssp-markdown --output my-ssp
   ```

8. Validate and provide summary:
   - Number of controls addressed
   - Implementation status breakdown
   - Any controls with missing responses
