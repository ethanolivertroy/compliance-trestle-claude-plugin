---
description: List all available trestle data conversion tasks
allowed-tools: Bash
user-invocable: true
argument-hint: ""
---

List all available trestle tasks for converting data formats to/from OSCAL.

## Steps

1. Run the task list command:
   ```
   trestle task -l
   ```

2. Present the results grouped by conversion direction:

   **Into OSCAL:**
   - `csv-to-oscal-cd` — CSV → Component Definition
   - `xlsx-to-oscal-cd` — XLSX → Component Definition
   - `xlsx-to-oscal-profile` — XLSX → Profile
   - `xccdf-result-to-oscal-ar` — XCCDF scan results → Assessment Results
   - `tanium-result-to-oscal-ar` — Tanium results → Assessment Results
   - `cis-xlsx-to-oscal-catalog` — CIS benchmark XLSX → Catalog
   - `cis-xlsx-to-oscal-cd` — CIS benchmark XLSX → Component Definition
   - `ocp4-cis-profile-to-oscal-catalog` — OCP4 CIS profile → Catalog
   - `ocp4-cis-profile-to-oscal-cd` — OCP4 CIS profile → Component Definition

   **From OSCAL:**
   - `oscal-catalog-to-csv` — Catalog → CSV
   - `oscal-profile-to-osco-profile` — Profile → OSCO YAML

3. Mention that task configuration goes in `.trestle/config.ini` under `[task.<task_name>]` sections. Use `trestle task <name> -i` to see required config for a specific task.
