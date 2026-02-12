---
description: Full profile authoring workflow - generate, edit, and assemble
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
user-invocable: true
disable-model-invocation: true
argument-hint: "<profile_name>"
---

Execute the full profile authoring roundtrip workflow.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for the profile name. If not provided, list available profiles and ask the user to choose.

3. **Pre-check: Verify profile imports resolve**. Read the profile JSON at
   `profiles/<profile_name>/profile.json` and inspect `profile.imports[].href`.
   For each import:
   - If href is `trestle://catalogs/<name>/catalog.json`, verify `catalogs/<name>/` exists in the workspace.
   - If href is an external URL, warn the user it must be accessible.
   - If a referenced catalog doesn't exist, tell the user to either:
     a. Import the catalog under the expected name: `trestle import -f <source> -o <expected_name>`
     b. Update the profile's href: `trestle href -n <profile_name> -hr trestle://catalogs/<actual_name>/catalog.json`
   - Do NOT proceed until imports resolve — the generate will fail otherwise.

4. **Generate Phase**:
   ```
   trestle author profile-generate --name <profile_name> --output <profile_name>-markdown
   ```

5. Show the structure and explain:
   - `values:` shows catalog defaults, `profile-values:` are overrides
   - `x-trestle-sections` maps section names
   - Profile-specific sections can be added
   - Control statement is read-only (comes from catalog)

6. **Edit Phase**: Guide the user:
   - Show a sample control with profile additions
   - Explain how to set profile-values for parameters
   - Explain how to add sections (implementation guidance, expected evidence, etc.)

7. **Assemble Phase**:
   ```
   trestle author profile-assemble --markdown <profile_name>-markdown --output <profile_name> --set-parameters
   ```

8. Optionally resolve the profile to see effective controls:
   ```
   trestle author profile-resolve --name <profile_name> --output <profile_name>-resolved
   ```

9. Validate and report results.
