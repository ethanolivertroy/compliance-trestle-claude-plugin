---
description: Assemble edited profile markdown back into OSCAL JSON
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<markdown_dir> <output_profile>"
---

Assemble edited profile markdown into an OSCAL JSON profile.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `markdown_dir` (`--markdown`): Directory with edited markdown
   - `output_profile` (`--output`): Name for assembled profile
   - Optional: `--name`: Source profile for metadata
   - Optional: `--set-parameters`: Apply parameter changes
   - Optional: `--sections`: Define sections (short_name:Long Name,...)
   - Optional: `--required-sections`: Required sections (comma-separated short names)
   - Optional: `--allowed-sections`: Allowed sections (comma-separated short names)
   - Optional: `--version`: Version string
   - Optional: `--regenerate`: New UUIDs

3. Run:
   ```
   trestle author profile-assemble --markdown <markdown_dir> --output <output_profile> [--set-parameters] [--sections "impl:Implementation Guidance"]
   ```

4. Assembly will fail if `--required-sections` are missing or disallowed sections are present.

5. Show output and suggest next steps.
