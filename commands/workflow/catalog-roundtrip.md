---
description: Full catalog authoring workflow - generate, edit, and assemble
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<catalog_name>"
---

Execute the full catalog authoring roundtrip workflow.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for the catalog name. If not provided, list available catalogs and ask the user to choose.

3. **Generate Phase**: Generate markdown from the catalog:
   ```
   trestle author catalog-generate --name <catalog_name> --output <catalog_name>-markdown
   ```

4. Show the generated markdown structure and explain:
   - Each control has its own `.md` file organized by group directories
   - YAML header contains `x-trestle-set-params` with parameter values
   - Control statement can be modified (add items, change prose)
   - Parameter values can be set in the YAML header

5. **Edit Phase**: Guide the user to edit the markdown files:
   - Show a sample control file
   - Explain what can be changed: prose, parameter values, guidance
   - Ask the user what they would like to edit or if they want to proceed

6. **Assemble Phase**: When the user is ready, assemble back to JSON:
   ```
   trestle author catalog-assemble --markdown <catalog_name>-markdown --output <catalog_name> --set-parameters
   ```

7. Validate the assembled catalog:
   ```
   trestle validate -t catalog -n <catalog_name>
   ```

8. Report results and explain the cycle can be repeated.
