# Contributing to Rails Kit

Report bugs, suggest skills, and ask questions in [GitHub Issues](https://github.com/svyatov/rails-kit/issues). For a new skill, explain the Rails or Ruby task, what existing skills do not cover, and which primary sources support the proposed workflow.

## Setup and layout

Clone the repository and run its dependency-free validator with Ruby:

```sh
git clone https://github.com/svyatov/rails-kit.git
cd rails-kit
ruby scripts/validate.rb
```

Rails Kit is one plugin, with its manifest at `.claude-plugin/plugin.json`, icon at `assets/icon.png`, and each skill at `skills/<name>/SKILL.md`. Supporting references belong beside the skill in `references/`. Both `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` register the repository root as `rails-kit`.

## Skill requirements

- Keep skills explicitly callable: set `disable-model-invocation: true` in skill frontmatter and `policy.allow_implicit_invocation: false` in `agents/openai.yaml`. Keep user invocation enabled.
- Keep each skill description identical in its frontmatter and README skill table. Keep the kit description identical in its plugin manifest, Claude Code catalog, and README introduction.
- Prefer official documentation for the application's Rails and Ruby versions and preserve existing application conventions. Identify optional gems and architectural preferences as optional.
- Preserve attribution and licenses for adapted material. Put source references beside the skill and link them from its instructions.
- Require evidence for audit findings and verification for proposed fixes. Exercise changed workflows in a representative application and report what you actually checked.

See [AGENTS.md](AGENTS.md) for the repository's maintenance rules.

## Validation

Run this for every change:

```sh
ruby scripts/validate.rb
ruby scripts/validate_test.rb
```

For changes to Rails upgrade detection, also run:

```sh
ruby skills/upgrade-rails/tests/detection_test.rb
ruby skills/upgrade-rails/references/ombulabs/detection-scripts/scan_patterns.rb --self-test
ruby skills/upgrade-rails/references/ombulabs/detection-scripts/gem_limits.rb --self-test
```

If Claude Code is available, validate the marketplace and its root plugin:

```sh
claude plugin validate --strict .
```

CI runs the Ruby checks and strict Claude Code validation for the marketplace and root plugin. Packaging checks do not prove that a skill's advice works in a Rails application.

## Pull requests

1. Branch from `main` with a name such as `docs/improve-installation` or `feat/new-skill`.
2. Make one focused change, update the README catalog when needed, and record it under `Unreleased` in [CHANGELOG.md](CHANGELOG.md). A new plugin keeps its initial version until first publication.
3. Run the relevant checks and open a pull request against `main` with the problem, resulting behavior, source references, and validation evidence.

Use Conventional Commit titles, such as `docs(readme): clarify plugin installation`. Pull requests use squash merge.
