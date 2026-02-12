---
description: Validate and enforce YAML header consistency across markdown documents
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<mode> -tn <task_name>"
---

Validate or enforce YAML header consistency across governed markdown documents.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `mode` (positional): One of `setup`, `template-validate`, `validate`, `create-sample`
   - `-tn` / `--task-name` (required unless `--global`): Name of the governance task
   - `-g` / `--global` (optional): Use the global template at `.trestle/author/__global__/`
   - `-r` / `--recurse` (optional): Recurse into subdirectories during validation
   - `-rv` / `--readme-validate` (optional): Include README.md files in validation
   - `-tv` / `--template-version` (optional): Specific template version to use
   - `-ig` / `--ignore` (optional): Regex pattern for files/folders to ignore

3. Execute the appropriate mode:

   **setup** — Create template directory and initial template:
   ```
   trestle author headers setup -tn <task_name>
   ```
   Creates `.trestle/author/<task_name>/` with a template file.

   **template-validate** — Check that the template itself is valid:
   ```
   trestle author headers template-validate -tn <task_name>
   ```
   Validates markdown and drawio template files for structural integrity.

   **validate** — Validate instance documents against the template:
   ```
   trestle author headers validate -tn <task_name> [-r]
   ```
   Checks that markdown files in `<task_name>/` have YAML headers matching the template structure.

4. Show results and explain any validation failures:
   - Missing required header fields
   - Header fields with wrong types
   - Extra fields not in the template (if strict mode)

5. Note: `create-sample` is not supported for headers-only governance. Use `trestle author docs` for full document governance with sample creation.
