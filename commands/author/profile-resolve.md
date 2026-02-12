---
description: Resolve a profile to produce a flattened catalog
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<profile_name> <output_catalog>"
---

Resolve a profile to produce its resolved profile catalog (flattened catalog with all modifications applied).

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `profile_name` (`--name`): Profile to resolve
   - `output_catalog` (`--output`): Name for the resolved catalog

3. Run:
   ```
   trestle author profile-resolve --name <profile_name> --output <output_catalog>
   ```

4. This creates a JSON catalog that represents the fully resolved view:
   - All imported controls are included
   - All parameter modifications are applied
   - All profile additions are incorporated

5. The resolved catalog appears in `catalogs/<output_catalog>/catalog.json`.

6. Note: This does NOT involve markdown - it's a direct JSON-to-JSON operation.

7. Useful for: seeing the effective controls after all profile modifications, as input to SSP generation, or for distribution.
