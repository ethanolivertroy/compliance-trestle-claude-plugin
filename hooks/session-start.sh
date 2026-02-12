#!/bin/bash
set -euo pipefail

# Session start hook: detect trestle workspace and provide context

# Check if we're in a trestle workspace
if [[ ! -d ".trestle" ]]; then
  exit 0
fi

# We're in a trestle workspace — gather context
models=()
model_dirs=("catalogs" "profiles" "component-definitions" "system-security-plans" "assessment-plans" "assessment-results" "plan-of-action-and-milestones")

for dir in "${model_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    count=$(find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$count" -gt 0 ]]; then
      models+=("$dir ($count)")
    fi
  fi
done

# Check for assembled outputs
dist_count=0
if [[ -d "dist" ]]; then
  dist_count=$(find "dist" -name '*.json' -o -name '*.yaml' -o -name '*.yml' 2>/dev/null | wc -l | tr -d ' ')
fi

# Check for local plugin settings
settings_info=""
settings_file=".claude/compliance-trestle.local.md"
if [[ -f "$settings_file" ]]; then
  settings_info="Project settings loaded from $settings_file."
fi

# Build output message
echo "Trestle workspace detected."

if [[ ${#models[@]} -gt 0 ]]; then
  model_list=$(printf '%s, ' "${models[@]}")
  echo "Models: ${model_list%, }."
fi

if [[ "$dist_count" -gt 0 ]]; then
  echo "Assembled outputs: $dist_count files in dist/."
fi

if [[ -n "$settings_info" ]]; then
  echo "$settings_info"
fi

echo "Use /compliance-trestle:workspace-status for details or /compliance-trestle:workspace-validate to check model health."
