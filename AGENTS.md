# Rails Kit

A collection of Rails-related skills, distributed as individually installable plugins for Claude Code and Codex.

## Layout

- Keep each plugin in `plugins/<name>/`, with `.claude-plugin/plugin.json` and `skills/<name>/SKILL.md`.
- Put supporting references beside the skill in `references/` and link them from the skill when needed.
- Keep both marketplace catalogs in sync: `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`.

## Changes

- Keep the plugin description identical in its manifest, the Claude Code catalog, and the README skill table.
- Preserve source attribution and licenses when copying skills.
- Record changes under `Unreleased` in `CHANGELOG.md`. A new plugin keeps its initial version until its first publication.
- Preserve invocation policy across hosts. A skill with `disable-model-invocation: true` also needs `agents/openai.yaml` with `policy.allow_implicit_invocation: false`.
- Validate JSON, skill frontmatter, catalog paths, and local Markdown references after changes. If Claude Code is available, also run `claude plugin validate --strict .` and `claude plugin validate --strict plugins/<name>` for each changed plugin.
