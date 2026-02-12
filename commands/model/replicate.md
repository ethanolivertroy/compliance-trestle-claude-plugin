---
description: Replicate (copy/rename) an OSCAL model in the workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "<type> <source_name> <new_name>"
---

Replicate an OSCAL model to create a copy with a new name.

## Steps

1. Verify we are in a trestle workspace.

2. Parse $ARGUMENTS for:
   - `type`: The model type (catalog, profile, etc.)
   - `source_name` (`-n`): The existing model name to copy
   - `new_name` (`-o`): The name for the new copy

3. Run the replicate command:
   ```
   trestle replicate <type> -n <source_name> -o <new_name>
   ```

4. This copies the entire model directory structure with new UUIDs.

5. Show the new model location and confirm success.

6. Note: All UUIDs are regenerated in the copy to ensure uniqueness.
