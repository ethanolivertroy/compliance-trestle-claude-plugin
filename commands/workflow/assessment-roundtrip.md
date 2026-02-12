---
description: Full assessment workflow — create/import, split, edit, merge, and validate assessment plans and results
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "[assessment-plan|assessment-results] [<name>] [--from-ssp <ssp_name>]"
---

Execute the full assessment plan or assessment results authoring workflow using the JSON-based create/split/edit/merge/validate cycle.

**Note**: Assessment models do not have `trestle author` generate/assemble commands. This workflow uses `trestle create`, `trestle split`, direct JSON editing, `trestle merge`, and `trestle validate`.

## Steps

1. **Verify workspace**: Confirm we are in a trestle workspace (`.trestle/` directory exists).

2. **Parse $ARGUMENTS** for:
   - `model_type`: Either `assessment-plan` or `assessment-results` (default: ask user)
   - `name`: Name for the model (default: ask user)
   - Optional `--from-ssp <ssp_name>`: SSP to reference in the assessment

3. **Pre-check references**:
   - If `--from-ssp` provided, verify the SSP exists in `system-security-plans/`
   - If creating assessment-results, check for existing assessment-plans to reference
   - List available SSPs and assessment plans for the user to choose from

4. **Detect or confirm model type**:
   - If not specified, ask: "Are you creating an assessment-plan or assessment-results?"
   - For assessment-results, check if an assessment-plan exists to reference via `import-ap`

5. **Create or Import**:
   - For new models:
     ```
     trestle create -t <model_type> -o <name>
     ```
   - Note: `trestle create` generates placeholder `REPLACE_ME` values that must be filled in

6. **Split with appropriate element paths**:

   For **assessment-plan**:
   ```
   cd assessment-plans/<name>
   trestle split -f assessment-plan.json -e 'assessment-plan.import-ssp,assessment-plan.reviewed-controls,assessment-plan.assessment-subjects,assessment-plan.assessment-assets,assessment-plan.tasks,assessment-plan.local-definitions'
   ```

   For **assessment-results**:
   ```
   cd assessment-results/<name>
   trestle split -f assessment-results.json -e 'assessment-results.import-ap,assessment-results.results'
   ```

7. **Guide editing each section** with JSON examples:

   For **assessment-plan**, guide through each split file:
   - `import-ssp`: Set the SSP href (use `--from-ssp` value if provided)
   - `reviewed-controls`: Define which controls are in scope for assessment
   - `assessment-subjects`: Define what systems/components are being assessed
   - `local-definitions`: Define activities with methods (EXAMINE, INTERVIEW, TEST)
   - `assessment-assets`: Document tools and assessment platforms
   - `tasks`: Schedule assessment activities with timing

   For **assessment-results**, guide through each split file:
   - `import-ap`: Set the assessment plan href
   - `results`: Build result sets containing:
     - `reviewed-controls`: Controls that were assessed
     - `observations`: Evidence collected (with methods, types, collected dates)
     - `risks`: Identified risks (with characterizations: likelihood, impact)
     - `findings`: Per-control findings with target status (`satisfied` / `not-satisfied`)
     - Link findings → observations → risks via UUIDs

   Show concrete JSON snippets for each section. See the `trestle-assessment` skill for complete examples.

8. **Merge**:

   For **assessment-plan**:
   ```
   trestle merge -e 'assessment-plan.import-ssp,assessment-plan.reviewed-controls,assessment-plan.assessment-subjects,assessment-plan.assessment-assets,assessment-plan.tasks,assessment-plan.local-definitions'
   ```

   For **assessment-results**:
   ```
   trestle merge -e 'assessment-results.import-ap,assessment-results.results'
   ```

9. **Validate**:
   ```
   trestle validate -t <model_type> -n <name>
   ```

10. **Summary and next steps**:
    - Report what was created/edited
    - For assessment-plan: suggest creating assessment-results next
    - For assessment-results: show findings summary (satisfied vs. not-satisfied counts)
    - For assessment-results with `not-satisfied` findings: suggest creating a POA&M using `/compliance-trestle:workflow-poam-roundtrip`
    - Remind about the `assessment-reviewer` agent for reviewing assessment documentation
