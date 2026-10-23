# Rails Kit

A collection of Rails-related skills, distributed as one Rails Kit plugin for Claude Code and Codex.

## Layout

- Keep the plugin manifest at `.claude-plugin/plugin.json` and each skill at `skills/<name>/SKILL.md`.
- Put supporting references beside the skill in `references/` and link them from the skill when needed.
- Keep both marketplace catalogs in sync: `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`.

## Changes

- Keep the plugin description identical in its manifest, the Claude Code catalog, and the README introduction. Keep each skill description identical in its frontmatter and the README skill table.
- Preserve source attribution and licenses when copying skills.
- Record changes under `Unreleased` in `CHANGELOG.md`. A new plugin keeps its initial version until its first publication.
- Every skill is explicitly callable only: set `disable-model-invocation: true` and `agents/openai.yaml` with `policy.allow_implicit_invocation: false`. Keep user invocation enabled and descriptions human-facing.
- Treat current official documentation for the target Rails/Ruby versions as authoritative. Prefer native Rails APIs and existing application conventions; label optional gems and architectural preferences as optional rather than framework requirements.
- Run `ruby scripts/validate.rb` after changes; it enforces invocation policy, catalog consistency, frontmatter, descriptions, and local references. When changing the validator, also run `ruby scripts/validate_test.rb`.
- Validate JSON, skill frontmatter, catalog paths, and local Markdown references after changes. If Claude Code is available, also run `claude plugin validate --strict .`.
