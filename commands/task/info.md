---
description: Show configuration requirements for a specific trestle task
allowed-tools: Bash
user-invocable: true
argument-hint: "<task_name>"
---

Show the configuration requirements and options for a specific trestle task.

## Steps

1. Parse $ARGUMENTS for:
   - `task_name`: The task to get info about

2. Run the task info command:
   ```
   trestle task <task_name> -i
   ```

3. Present the output, which includes:
   - Required configuration keys
   - Optional configuration keys with defaults
   - Expected input/output formats
   - Example config.ini section

4. Show a sample `config.ini` section for the task:
   ```ini
   [task.<task_name>]
   input-dir = data/input
   output-dir = component-definitions/my-component
   ```

5. Explain that this section goes in `.trestle/config.ini` and the task is run with:
   ```
   trestle task <task_name>
   ```
