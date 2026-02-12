---
description: Generate SSP markdown from a profile and optional component definitions
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<profile_name> [--compdefs comp1,comp2] <output_dir>"
---

Generate System Security Plan (SSP) markdown from a profile and optional component definitions.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name` (`--profile`): Profile defining the control baseline
   - `output_dir` (`--output`): Markdown output directory
   - Optional: `--compdefs`: Comma-separated list of component-definition names
   - Optional: `--yaml`, `--overwrite-header-values`, `--force-overwrite`
   - Optional: `--include-all-parts`: Include all parts (default: only parts with rules)

3. Ensure the profile's imports resolve correctly (use `trestle href` if needed).

4. Run:
   ```
   trestle author ssp-generate --profile <profile_name> --output <output_dir> [--compdefs <comp1,comp2>]
   ```

5. Show the generated structure:
   - One markdown file per control
   - Each control has sections per statement part
   - Each part has response sections per component
   - "This System" component is always present
   - Named components come from component definitions

6. Explain the markdown structure:
   - YAML header: parameters, rules, rule parameters
   - Control statement (read-only)
   - Implementation sections per part per component
   - `#### Implementation Status:` per component
   - `#### Rules:` (read-only, from component definitions)

7. Explain what to edit:
   - Replace `<!-- Add control implementation description here -->` comments with prose
   - Set `ssp-values:` for parameters
   - Set implementation status values
   - Add implementation prose for each component per statement part

8. Next steps: Edit all control responses, then `ssp-assemble`.
