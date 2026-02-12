---
description: Full POA&M workflow — create from assessment findings, track remediation, manage milestones
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<name> [--from-assessment <assessment_results_name>] [--from-ssp <ssp_name>]"
---

Execute the full Plan of Action and Milestones (POA&M) workflow using the JSON-based create/split/edit/merge/validate cycle.

**Note**: POA&M does not have `trestle author` generate/assemble commands. This workflow uses `trestle create`, `trestle split`, direct JSON editing, `trestle merge`, and `trestle validate`.

## Steps

1. **Verify workspace**: Confirm we are in a trestle workspace (`.trestle/` directory exists).

2. **Parse $ARGUMENTS** for:
   - `name`: Name for the POA&M (required, or ask user)
   - Optional `--from-assessment <assessment_results_name>`: Assessment results to extract findings from
   - Optional `--from-ssp <ssp_name>`: SSP to reference in the POA&M

3. **Pre-check references**:
   - If `--from-assessment` provided, verify assessment results exist in `assessment-results/`
   - If `--from-ssp` provided, verify the SSP exists in `system-security-plans/`
   - List available assessment results and SSPs for the user to choose from

4. **Extract findings from assessment results** (if `--from-assessment` provided):
   - Read the assessment results JSON
   - Find all findings with `target.status.state` = `not-satisfied`
   - Show a summary table:
     ```
     | Control | Finding Title | Risk Level | Observations |
     |---------|--------------|------------|--------------|
     | AC-1    | Outdated...  | High       | 1            |
     | SC-7    | Missing...   | Moderate   | 2            |
     ```
   - Ask the user to confirm which findings should become POA&M items

5. **Create the POA&M**:
   ```
   trestle create -t plan-of-action-and-milestones -o <name>
   ```

6. **Split for editing**:
   ```
   cd plan-of-action-and-milestones/<name>
   trestle split -f plan-of-action-and-milestones.json -e 'plan-of-action-and-milestones.import-ssp,plan-of-action-and-milestones.poam-items,plan-of-action-and-milestones.observations,plan-of-action-and-milestones.risks'
   ```

7. **Guide POA&M creation** for each split file:

   - **import-ssp**: Set the SSP href (use `--from-ssp` value if provided)

   - **observations**: Copy relevant observations from assessment results (preserving UUIDs for cross-referencing). Each observation should have:
     - `methods`: EXAMINE, INTERVIEW, or TEST
     - `types`: finding, historic, etc.
     - `collected`: Date the evidence was collected

   - **risks**: For each finding, create risk entries with:
     - `status`: Initial status (typically `open`)
     - `characterizations`: Likelihood and impact ratings
     - `remediations`: Planned actions with lifecycle (`recommendation` → `planned` → `completed`)
     - `tasks`: Milestones with timing (start/end date ranges)

   - **poam-items**: Create POA&M items linking to observations and risks:
     - `related-observations`: UUID references to observation entries
     - `related-risks`: UUID references to risk entries
     - `origins`: Who identified the finding

   If `--from-assessment` was used, pre-populate these sections from the extracted findings data.

   Show concrete JSON snippets for each section. See the `trestle-poam` skill for complete examples.

8. **Merge**:
   ```
   trestle merge -e 'plan-of-action-and-milestones.import-ssp,plan-of-action-and-milestones.poam-items,plan-of-action-and-milestones.observations,plan-of-action-and-milestones.risks'
   ```

9. **Validate**:
   ```
   trestle validate -t plan-of-action-and-milestones -n <name>
   ```

10. **Summary with risk breakdown and timeline**:
    - Total POA&M items created
    - Risk breakdown: items by risk level (high, moderate, low)
    - Status summary: open, investigating, remediating, deviation, closed
    - Milestone timeline: upcoming milestone dates
    - Recommend the `poam-manager` agent for ongoing remediation tracking
    - Remind about using Jinja templates for POA&M status reports (see `trestle-jinja-templating` skill)
