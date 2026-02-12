---
description: Generate an inheritance view from a profile and leveraged SSP
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<profile_name> --leveraged-ssp <ssp_name> <output_dir>"
---

Generate an inheritance view by filtering a parent profile based on inherited controls from a leveraged SSP.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name` (`--name`): Parent profile name
   - `ssp_name` (`--leveraged-ssp`): Name of the SSP being leveraged
   - `output_dir` (`--output`): Output directory

3. Run:
   ```
   trestle author profile-inherit --name <profile_name> --leveraged-ssp <ssp_name> --output <output_dir>
   ```

4. This filters the profile's controls based on what is inherited from the leveraged SSP.

5. Explain the inheritance concept:
   - Provider systems expose inherited controls via their SSP
   - Consumer systems leverage those controls
   - This command shows which controls are inherited vs. need local implementation
