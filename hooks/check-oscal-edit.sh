#!/bin/bash
set -euo pipefail

# PreToolUse hook: warn when directly editing OSCAL JSON/YAML files
# in model directories (should use trestle authoring workflow instead)

input=$(cat)

# Extract file path from tool input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)

if [[ -z "$file_path" ]]; then
  exit 0
fi

# Check if we're in a trestle workspace
if [[ ! -d ".trestle" ]]; then
  exit 0
fi

# OSCAL model directories that have trestle author commands (markdown roundtrip)
author_dirs="catalogs/|profiles/|component-definitions/|system-security-plans/"

# OSCAL model directories that use JSON-based workflow (no author commands)
json_workflow_dirs="assessment-plans/|assessment-results/|plan-of-action-and-milestones/"

# Check if the file is a JSON/YAML file inside an OSCAL model directory
if echo "$file_path" | grep -qE '\.(json|yaml|yml)$'; then
  if echo "$file_path" | grep -qE "($author_dirs)"; then
    cat >&2 <<'EOF'
{"systemMessage": "Warning: You are directly editing an OSCAL model file. Direct JSON/YAML edits bypass trestle's authoring workflow and may cause validation issues. Consider using the trestle author generate/assemble roundtrip workflow instead, which preserves model integrity and validates changes. If this edit is intentional (e.g., fixing a specific field), proceed carefully and validate afterward with: trestle validate -a"}
EOF
    exit 2
  fi

  if echo "$file_path" | grep -qE "($json_workflow_dirs)"; then
    cat >&2 <<'EOF'
{"systemMessage": "Note: You are editing an OSCAL model that uses the JSON-based workflow (no trestle author commands available for this model type). This is the correct approach — use trestle split/merge to manage sections and validate afterward with: trestle validate -a"}
EOF
    exit 0
  fi
fi

exit 0
