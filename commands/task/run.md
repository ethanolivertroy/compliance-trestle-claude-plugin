---
description: Run a trestle data conversion task (CSV/XLSX/XCCDF → OSCAL)
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<task_name> [-c config.ini]"
---

Run a trestle task to convert external data formats into OSCAL documents.

## Steps

1. Verify we are in a trestle workspace (check for `.trestle/` directory).

2. Parse $ARGUMENTS for:
   - `task_name`: The task to run (e.g., `csv-to-oscal-cd`, `xccdf-result-to-oscal-ar`)
   - `-c` / `--config` (optional): Path to config file (defaults to `.trestle/config.ini`)

3. Verify the task name is valid by checking against known tasks:
   - `csv-to-oscal-cd` — CSV → Component Definition
   - `xlsx-to-oscal-cd` — XLSX → Component Definition
   - `xlsx-to-oscal-profile` — XLSX → Profile
   - `xccdf-result-to-oscal-ar` — XCCDF scan results → Assessment Results
   - `tanium-result-to-oscal-ar` — Tanium results → Assessment Results
   - `oscal-catalog-to-csv` — Catalog → CSV
   - `oscal-profile-to-osco-profile` — Profile → OSCO YAML
   - `cis-xlsx-to-oscal-catalog` — CIS benchmark XLSX → Catalog
   - `cis-xlsx-to-oscal-cd` — CIS benchmark XLSX → Component Definition
   - `ocp4-cis-profile-to-oscal-catalog` — OCP4 CIS profile → Catalog
   - `ocp4-cis-profile-to-oscal-cd` — OCP4 CIS profile → Component Definition

4. Read the config file and check for a `[task.<task_name>]` section. Show the user the current configuration. If no config section exists, inform the user they need to add one.

5. Run the task:
   ```
   trestle task <task_name> -c <config_file>
   ```

6. Check the output directory specified in the config for the generated OSCAL file(s).

7. Suggest validating the output:
   ```
   trestle validate -f <output_file>
   ```
