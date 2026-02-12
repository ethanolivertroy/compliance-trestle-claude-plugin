---
description: Enforce governed markdown document structure using templates
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<mode> -tn <task_name>"
---

Set up and enforce governed markdown document structure using templates.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `mode` (positional): One of `setup`, `create-sample`, `template-validate`, `validate`
   - `-tn` / `--task-name` (required): Name of the governance task
   - `-gh` / `--governed-heading` (optional): Heading to enforce in document structure
   - `-hv` / `--header-validate` (optional): Validate YAML header structure
   - `-hov` / `--header-only-validate` (optional): Only validate the YAML header, not body
   - `-tv` / `--template-version` (optional): Specific template version to use
   - `-ig` / `--ignore` (optional): Regex pattern for files/folders to ignore
   - `-r` / `--recurse` (optional): Recurse into subdirectories
   - `-rv` / `--readme-validate` (optional): Include README.md in validation
   - `-vtt` / `--validate-template-type` (optional): Validate using `x-trestle-template-type` field

3. Execute the appropriate mode:

   **setup** — Create template directory and `template.md`:
   ```
   trestle author docs setup -tn <task_name>
   ```
   Creates `.trestle/author/<task_name>/template.md` with a sample structure.

   **create-sample** — Generate a new document from the template:
   ```
   trestle author docs create-sample -tn <task_name>
   ```
   Copies the template to `<task_name>/<task_name>_NNN.md` with an incremental number.

   **template-validate** — Validate the template file:
   ```
   trestle author docs template-validate -tn <task_name>
   ```

   **validate** — Validate all documents against the template:
   ```
   trestle author docs validate -tn <task_name> [-hv] [-gh "Heading Name"]
   ```
   Checks document structure, headings, and optionally YAML headers.

4. Explain governance concepts:
   - Templates live in `.trestle/author/<task_name>/`
   - Documents live in `<task_name>/` at the workspace root
   - Template versioning uses `x-trestle-template-version` in YAML headers
   - Governed headings enforce that specific sections exist in documents
   - This enables CI/CD validation of compliance documentation
