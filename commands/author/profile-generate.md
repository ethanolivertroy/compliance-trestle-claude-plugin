---
description: Generate markdown from an OSCAL profile for editing
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
argument-hint: "<profile_name> <output_dir>"
---

Generate editable markdown from an OSCAL profile's resolved catalog.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name` (`--name`): Name of profile in workspace
   - `output_dir` (`--output`): Directory for markdown output
   - Optional: `--yaml` / `-y`: YAML header file
   - Optional: `--overwrite-header-values`: Overwrite existing headers
   - Optional: `--force-overwrite`: Erase and regenerate

3. **Pre-check: Verify profile imports resolve**. Read the profile JSON at
   `profiles/<profile_name>/profile.json` and inspect `profile.imports[].href`.
   For each import:
   - If href is `trestle://catalogs/<name>/catalog.json`, verify `catalogs/<name>/` exists in the workspace.
   - If href is an external URL, warn the user it must be accessible.
   - If a referenced catalog doesn't exist, tell the user to either:
     a. Import the catalog under the expected name: `trestle import -f <source> -o <expected_name>`
     b. Update the profile's href: `trestle href -n <profile_name> -hr trestle://catalogs/<actual_name>/catalog.json`
   - Do NOT proceed until imports resolve — the generate will fail otherwise.

4. Run:
   ```
   trestle author profile-generate --name <profile_name> --output <output_dir>
   ```

5. Show the markdown structure. Each control will have:
   - `values:` (from catalog) and `profile-values:` (profile overrides) in YAML header
   - `x-trestle-sections` mapping section short names to display names
   - Control statement (read-only from catalog)
   - Editable sections for profile additions

6. Explain editing:
   - Set `profile-values:` to override catalog parameter values
   - Add content to profile-specific sections
   - The `values:` field shows catalog defaults (informational)

7. Next steps: Edit, then `profile-assemble`.
