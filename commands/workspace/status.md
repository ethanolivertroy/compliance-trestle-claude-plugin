---
description: Show the status of the current Trestle workspace
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: ""
---

Display the status of the current Compliance Trestle workspace.

## Steps

1. Check if the current directory (or any parent) contains a `.trestle/` directory. If not, inform the user they are not in a trestle workspace.

2. List all OSCAL models in the workspace by scanning each model directory:
   - `catalogs/` - List catalog names
   - `profiles/` - List profile names
   - `component-definitions/` - List component definition names
   - `system-security-plans/` - List SSP names
   - `assessment-plans/` - List assessment plan names
   - `assessment-results/` - List assessment result names
   - `plan-of-action-and-milestones/` - List POA&M names

3. For each model found, show:
   - Model name
   - Whether it has been split (check for subdirectories)
   - Whether an assembled version exists in `dist/`

4. Check for any markdown authoring directories (output of generate commands).

5. **Check configured tasks**: Read `.trestle/config.ini` for `[task.*]` sections and report:
   - Task name (from the section header, e.g., `[task.csv-to-oscal-cd]`)
   - Input path (from `input-dir`, `input-file`, or `csv-file` keys)
   - Output path (from `output-dir` key)
   - Whether the output directory exists and contains generated files

6. Show the trestle version: `trestle version`

7. Present a summary table of workspace contents.
