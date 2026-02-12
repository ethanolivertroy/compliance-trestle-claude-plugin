---
description: View or update profile import hrefs to point to local workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<profile_name> [--href <new_href>]"
---

View or update the import href(s) in a profile to point to catalogs/profiles in the local trestle workspace.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name` (`-n` / `--name`): Name of the trestle profile to inspect or modify
   - `href` (`-hr` / `--href`, optional): New href value to set
   - `item` (`-i` / `--item`, optional): Index of the import href to modify (default: 0)

3. Verify the profile exists in `profiles/<profile_name>/`.

4. If no `--href` provided, **view mode** — list current import hrefs:
   - Read the profile and show all import entries with their current href values
   - Show which catalogs/profiles they reference

5. If `--href` provided, **update mode** — change the href:
   ```
   trestle href -n <profile_name> -hr <new_href>
   ```

   Common href formats:
   - `trestle://catalogs/my-catalog/catalog.json` — local workspace catalog
   - `trestle://profiles/my-profile/profile.json` — local workspace profile
   - `https://...` — remote OSCAL document URL

6. After updating, verify the import resolves correctly by checking that the referenced model exists in the workspace.
