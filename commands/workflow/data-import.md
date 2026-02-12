---
description: Guided workflow to import data into a trestle workspace — OSCAL files via trestle import, or external formats (CSV/XLSX/XCCDF/Tanium) via trestle tasks
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<file_or_url> [--type catalog|profile|component-definition|ssp]"
---

Execute a guided data import workflow. Handles both native OSCAL imports and external-format conversions.

## Steps

1. Verify we are in a trestle workspace (check for `.trestle/` directory).

2. Parse $ARGUMENTS for the source file path or URL and optional `--type` flag. If not provided, ask the user:
   - What file or URL to import from
   - What model type it is (or let the tool detect it)

3. **Detect format** — Examine the source to determine the import path:

   **Path A — Native OSCAL** (JSON/YAML with OSCAL top-level keys like `catalog`, `profile`, `component-definition`, `system-security-plan`, etc.):
   - For URLs: fetch the file and save to a temp location
   - Auto-detect the model type from the file content if `--type` was not specified

   **Path B — External format** (requires conversion via `trestle task`):
   - `.csv` → `csv-to-oscal-cd`
   - `.xlsx` / `.xls` → Check content for CIS benchmark indicators:
     - CIS benchmark → `cis-xlsx-to-oscal-cd` or `cis-xlsx-to-oscal-catalog`
     - General XLSX → `xlsx-to-oscal-cd` or `xlsx-to-oscal-profile`
   - `.xml` → Check for XCCDF namespace:
     - XCCDF results → `xccdf-result-to-oscal-ar`
   - `.json` (non-OSCAL) → Check for Tanium format:
     - Tanium results → `tanium-result-to-oscal-ar`

   If the format is ambiguous, ask the user which path to follow.

4. **Inspect source data**:
   - For OSCAL files: display the model type, title, and key metadata
   - For CSV: Read headers and first few rows, show column names
   - For XLSX: List sheet names and preview the data
   - For XML: Show root element and namespace to confirm XCCDF
   - For Tanium JSON: Show top-level structure

5. **Show Import Preview**:
   - Show the detected format and import method
   - Show where the output will go (e.g., `catalogs/<name>/catalog.json`)
   - Ask the user to confirm before proceeding

6. **Import / Convert**:

   **Path A — Native OSCAL import**:
   ```
   trestle import -f <source_file> -o <model_name>
   ```

   **Path B — External format conversion**:
   - Read `.trestle/config.ini` and either update an existing `[task.<name>]` section or create a new one
   - Set required keys based on the detected task (input path, output directory, title, version)
   - For CSV tasks, help map CSV columns to OSCAL fields
   - Show the proposed configuration and confirm before writing
   - Run:
     ```
     trestle task <task_name>
     ```

7. **Post-Import Validation**: Validate the result:
   ```
   trestle validate -t <model_type> -n <model_name>
   ```
   Or for task output:
   ```
   trestle validate -f <output_file>
   ```

8. **Report Results**:
   - Show the output model location in the workspace
   - Display validation results
   - Suggest next steps:
     - For catalogs: "Use `/compliance-trestle:catalog-roundtrip` to begin editing"
     - For profiles: "Use `/compliance-trestle:profile-roundtrip` to customize control selections"
     - For component-definitions: "Use `/compliance-trestle:component-roundtrip` to edit component controls"
     - For SSPs: "Use `/compliance-trestle:ssp-roundtrip` to author implementation responses"
     - For assessment results: suggest reviewing findings

## Notes

- **Path A** uses `trestle import` — supports JSON and YAML OSCAL files
- **Path B** uses `trestle task` — supports CSV, XLSX, XML (XCCDF), and Tanium JSON
- The model name is derived from the source filename by default
- If a model with the same name already exists, warn the user and ask whether to overwrite
- Config.ini settings for import/conversion tasks can be saved to `.trestle/config.ini` for reuse
