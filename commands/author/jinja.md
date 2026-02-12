---
description: Render Jinja2 templates against OSCAL data to generate documents
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<template> <output> [--ssp <name>] [--profile <name>]"
---

Render a Jinja2 template against OSCAL data (SSP, profile, catalog) to generate compliance documents.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `template` (`-i` / `--input`): Path to Jinja2 template file (relative to trestle root)
   - `output` (`-o` / `--output`): Output file path (relative to trestle root)
   - `--ssp` (optional): SSP name to pass as context
   - `--profile` / `-p` (optional): Profile name to pass as context
   - `--look-up-table` / `-lut` (optional): YAML key-value lookup table path
   - `--bracket-format` / `-bf` (optional): Bracket format for values (e.g., `[.]` or `((.))`)
   - `--number-captions` / `-nc` (optional): Add numbering to table/image captions
   - `--docs-profile` / `-dp` (optional): Profile for per-control markdown output
   - `--value-assigned-prefix` / `-vap` (optional): Prefix when value is assigned
   - `--value-not-assigned-prefix` / `-vnap` (optional): Prefix when value is not assigned

3. Run the Jinja render command:
   ```
   trestle author jinja -i <template> -o <output> [--ssp <ssp_name>] [-p <profile_name>] [-lut <yaml_path>]
   ```

4. Show the generated output file.

5. Explain the available template context objects:
   - When `--ssp` is provided: `ssp`, `catalog`, `catalog_interface`, `control_interface`, `ssp_md_writer`, `control_writer`
   - When `--profile` and `--docs-profile` are provided: `profile`, `control`, `group_title`
   - When `--look-up-table` is provided: key-value pairs available as variables

6. Mention available custom Jinja tags:
   - `{% mdsection_include "file.md" "Section Title" heading_level=2 %}` — Include a markdown section
   - `{% md_clean_include "file.md" heading_level=2 %}` — Include entire markdown file (strips frontmatter)
   - `{% md_datestamp format="%Y-%m-%d" newline=True %}` — Insert formatted date

7. Mention available custom Jinja filters:
   - `as_list` — Convert to list
   - `get_default` — Get default value
   - `first_or_none` — Get first element or None
   - `get_party` — Get party by UUID from SSP
   - `parties_for_role` — Get parties for a role ID
   - `diagram_href` — Get diagram link href
