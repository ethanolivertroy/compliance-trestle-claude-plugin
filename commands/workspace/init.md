---
description: Initialize a new Compliance Trestle workspace
allowed-tools: Bash, Read, Glob
user-invocable: true
argument-hint: "[--full | --local | --govdocs]"
---

Initialize a Compliance Trestle workspace in the current directory.

## Steps

1. Check if a `.trestle/` directory already exists in the current directory. If it does, inform the user that a trestle workspace already exists and ask if they want to reinitialize.

2. Determine the initialization mode from $ARGUMENTS:
   - `--full` (default): Full workspace with dist/, model dirs, and .trestle/
   - `--local`: Model dirs and .trestle/ only (no dist/)
   - `--govdocs`: Only .trestle/ for document governance

3. Run the trestle init command:
   ```
   trestle init [mode_flag]
   ```

4. Verify the workspace was created by checking for `.trestle/` directory.

5. Show the user the created directory structure using `ls` or tree-like output.

6. Explain what was created and suggest next steps:
   - For `--full`: Import or create OSCAL models, then use split/merge or author commands
   - For `--local`: Import or create OSCAL models for local management
   - For `--govdocs`: Set up document templates and governance rules
