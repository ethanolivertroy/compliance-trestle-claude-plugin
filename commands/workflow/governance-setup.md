---
description: Guided workflow to set up governance — workspace templates, config, and document-level enforcement via trestle author
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "[--template catalog|profile|ssp|component-definition] [--author <task_name> --type docs|headers|folders]"
---

Execute a guided governance setup workflow. Covers both workspace-level governance (template directories, config.ini, starter templates) and document-level governance (trestle author docs/headers/folders, validation, CI/CD).

## Steps

### Part 1 — Workspace-level governance

1. Verify we are in a trestle workspace (check for `.trestle/` directory). If not, offer to initialize one:
   ```
   trestle init
   ```

2. Parse $ARGUMENTS for an optional `--template` flag indicating which governance template to set up. If not provided, present a menu:
   - Catalog governance (review/edit catalog controls)
   - Profile governance (customize baselines)
   - SSP governance (author implementation responses)
   - Component-definition governance (define reusable compliance content)
   - Full governance (set up all of the above)

3. **Template Directory Setup**: Create the governance template directories as needed:
   ```
   mkdir -p .trestle/author/catalog/
   mkdir -p .trestle/author/profile/
   mkdir -p .trestle/author/ssp/
   mkdir -p .trestle/author/component-definition/
   ```
   Show the user which directories were created.

4. **Config.ini Setup**: Guide the user through setting up `.trestle/config.ini` for their project:
   - Read the existing config.ini (if present)
   - For each selected governance type, add task configuration sections:
     ```ini
     [task.catalog-generate]
     output = catalog-markdown

     [task.catalog-assemble]
     markdown = catalog-markdown
     set-parameters = true

     [task.profile-generate]
     output = profile-markdown

     [task.profile-assemble]
     markdown = profile-markdown
     set-parameters = true

     [task.ssp-generate]
     output = ssp-markdown

     [task.ssp-assemble]
     markdown = ssp-markdown
     compdefs = *
     ```
   - Ask the user if they want to customize any values

5. **Template Files**: For each governance type, create starter template files:
   - SSP: Create a `setup.md` template with sections for system description
   - Profile: Create notes on how to customize profile selections
   - Component: Create notes on defining components and rules

### Part 2 — Document-level governance (trestle author)

6. If `--author <task_name>` was passed, or if the user wants document-level enforcement, set up `trestle author` governance:
   - Ask the user what they want to enforce (if `--type` not specified):
     - YAML headers only → `headers`
     - Document structure (headings + headers) → `docs`
     - Entire folder structure → `folders`

   Run setup:
   ```
   trestle author <type> setup -tn <task_name>
   ```
   Show the created template files in `.trestle/author/<task_name>/`.

7. **Customize templates**:
   - Read the generated template file(s)
   - Help the user customize:
     - YAML header fields (required metadata like title, status, author, date)
     - Governed headings (required sections in the document)
     - Template version (`x-trestle-template-version`)
   - Write the customized template back

   Validate the template:
   ```
   trestle author <type> template-validate -tn <task_name>
   ```
   Fix any template issues before proceeding.

8. **Create and validate sample documents**:
   ```
   trestle author <type> create-sample -tn <task_name>
   ```
   Show the generated sample, then confirm it passes validation:
   ```
   trestle author <type> validate -tn <task_name> [-hv] [-gh "Section Name"]
   ```

9. **CI/CD suggestions**: Offer to help set up automated validation:
   - GitHub Actions workflow step
   - Pre-commit hook configuration
   - Makefile target
   - Show the exact command that should run in CI

### Summary

10. **Workspace Summary**: Show the final workspace structure:
    - List all created directories
    - Show config.ini contents
    - Show any template files created

11. **Next Steps**: Recommend what to do next:
    - Import source data: "Use `/compliance-trestle:data-import` to import catalogs or profiles"
    - Start authoring: "Use the roundtrip workflows to begin editing"
    - Review workspace: "Use the workspace-explorer agent to verify the setup"
