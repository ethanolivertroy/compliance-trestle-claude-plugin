---
description: Filter an SSP by profile or components
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<ssp_name> [--profile <profile> | --components <comp1,comp2>] <output_ssp>"
---

Filter a System Security Plan to include only specific controls or components.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `ssp_name` (`--name`): SSP to filter
   - Filter mode (one of):
     - `--profile <profile>`: Keep only controls in this profile
     - `--components <comp1,comp2>`: Keep only these components
     - `--exclude-components <comp1,comp2>`: Exclude these components
   - `output_ssp` (`--output`): Name for filtered SSP

3. Run the appropriate filter command:
   ```
   trestle author ssp-filter --name <ssp_name> --profile <profile> --output <output_ssp>
   ```
   or:
   ```
   trestle author ssp-filter --name <ssp_name> --components <comp1,comp2> --output <output_ssp>
   ```

4. Explain use cases:
   - Filter by profile: Create SSP subset for a specific compliance framework
   - Filter by components: Create SSP view for specific system components
   - Exclude components: Remove proprietary content before external distribution

5. Show output and confirm what was filtered.
