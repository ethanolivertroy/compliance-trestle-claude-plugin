---
description: Enforce governed folder structure using templates
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<mode> -tn <task_name>"
---

Set up and enforce governed folder structures using template directories.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `mode` (positional): One of `setup`, `create-sample`, `template-validate`, `validate`
   - `-tn` / `--task-name` (required): Name of the governance task
   - `-gh` / `--governed-heading` (optional): Heading to enforce in markdown files
   - `-hv` / `--header-validate` (optional): Validate YAML header structure
   - `-hov` / `--header-only-validate` (optional): Only validate YAML headers
   - `-tv` / `--template-version` (optional): Specific template version to use
   - `-ig` / `--ignore` (optional): Regex pattern for files/folders to ignore
   - `-rv` / `--readme-validate` (optional): Include README.md in validation
   - `-vtt` / `--validate-template-type` (optional): Validate using `x-trestle-template-type` field

3. Execute the appropriate mode:

   **setup** — Create template directory with sample files:
   ```
   trestle author folders setup -tn <task_name>
   ```
   Creates `.trestle/author/<task_name>/` with template files (e.g., `a_template.md`, `another_template.md`, `architecture.drawio`).

   **create-sample** — Generate a new folder instance from templates:
   ```
   trestle author folders create-sample -tn <task_name>
   ```
   Copies the entire template directory to `<task_name>/sample_folder_N/`.

   **template-validate** — Validate all template files:
   ```
   trestle author folders template-validate -tn <task_name>
   ```

   **validate** — Validate folder instances against template:
   ```
   trestle author folders validate -tn <task_name> [-hv]
   ```
   Checks that each folder in `<task_name>/` matches the template structure exactly — same files, same headings, same YAML headers.

4. Explain folder governance:
   - Template directory defines the required file structure
   - Each instance folder must mirror the template exactly
   - Supports both markdown (.md) and drawio (.drawio) files
   - Useful for enforcing consistent structure across multiple system components or assessments
   - Integrate with CI/CD to prevent structural drift
