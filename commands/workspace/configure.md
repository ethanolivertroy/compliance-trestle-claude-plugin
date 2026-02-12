---
description: Configure compliance-trestle plugin settings for this project
allowed-tools: Read, Write, Edit, Glob
user-invocable: true
argument-hint: "[--show | --reset]"
---

Manage per-project compliance-trestle plugin settings.

## Steps

1. Parse $ARGUMENTS:
   - `--show`: Display current settings and exit
   - `--reset`: Delete the settings file and exit
   - No arguments: Interactive configuration

2. Check for existing settings at `.claude/compliance-trestle.local.md`.

3. **If `--show`**: Read and display the settings file. If it doesn't exist, say "No project settings configured. Run `/workspace-configure` to set up."

4. **If `--reset`**: Delete `.claude/compliance-trestle.local.md` if it exists. Confirm deletion.

5. **Interactive configuration** (no arguments):

   If settings already exist, read them and show current values as defaults.

   Ask the user about each setting:

   - **auto_validate** (true/false, default: true) — Automatically remind to validate after assembly/import operations
   - **default_catalog** (string, default: empty) — Default catalog name for authoring workflows (e.g., `nist-800-53-rev5`)
   - **default_profile** (string, default: empty) — Default profile name for SSP generation
   - **validation_level** (strict/normal, default: normal) — `strict` treats warnings as errors
   - **ssp_format** (markdown/json, default: markdown) — Preferred SSP editing format

6. Write the settings file to `.claude/compliance-trestle.local.md`:

   ```markdown
   ---
   auto_validate: true
   default_catalog: nist-800-53-rev5
   default_profile: ""
   validation_level: normal
   ssp_format: markdown
   ---

   # Compliance Trestle Project Settings

   These settings configure the compliance-trestle plugin behavior for this project.
   Edit this file directly or run `/workspace-configure` to reconfigure.

   Settings are read by plugin hooks at session start and during workflows.
   This file is excluded from version control by the plugin's .gitignore.
   ```

7. Confirm the settings were saved and explain they take effect on next session start.

## Notes

- The `.claude/` directory must exist (create it if needed with `mkdir -p .claude`)
- Settings are gitignored by default (the plugin's `.gitignore` excludes `*.local.md`)
- Settings are read by the session-start hook to provide workspace context
