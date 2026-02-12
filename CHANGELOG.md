# Changelog

All notable changes to the compliance-trestle Claude Code plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-13

### Added
- Initial release of the compliance-trestle Claude Code plugin
- 10 skills: workspace, authoring workflow, OSCAL models, control implementation, assessment, POA&M, validation, task system, Jinja templating, governance
- Compliance pipeline skill — end-to-end pipeline covering GRC personas, artifact ownership, per-persona workflows, component definition bridge, multi-repo coordination, CI/CD integration, and Compliance-to-Policy (C2P)
- 9 agents: compliance-reviewer, ssp-author, control-mapper, workspace-explorer, assessment-reviewer, poam-manager, validation-assistant, data-importer, pipeline-architect
- 41 slash commands across workspace, author, model, task, and workflow categories
- 3 event hooks: session-start workspace detection, post-tool-use validation reminder, pre-tool-use OSCAL edit warning
- Worked examples and step-by-step walkthroughs across all skills
- Troubleshooting sections with common errors and solutions
- Cross-references between related skills
- Per-project configuration via `.claude/compliance-trestle.local.md`
