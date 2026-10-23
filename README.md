# Rails Kit

Rails-related skills for Claude Code and Codex. Each skill is an individually installable plugin. All skills require explicit invocation; none is selected automatically.

## Skills

| Skill | Description |
| --- | --- |
| [hyperdrive](plugins/hyperdrive/skills/hyperdrive/SKILL.md) | Set up and maintain Rails Hyperdrive in a Rails project: development-only gems, companion skills, MCP access, and safe content sync. |
| [test-performance](plugins/test-performance/skills/test-performance/SKILL.md) | Profile and speed up Rails tests with TestProf, targeted side-effect controls, lean factories, and safely shared fixtures. |
| [audit-active-record-concurrency](plugins/audit-active-record-concurrency/skills/audit-active-record-concurrency/SKILL.md) | Audit concurrent Active Record writes for duplicate records, lost updates, and broken database invariants. |
| [audit-n-plus-one](plugins/audit-n-plus-one/skills/audit-n-plus-one/SKILL.md) | Audit Rails query growth, locate N+1 queries, and verify loading or batching fixes with regression coverage. |
| [audit-transactions](plugins/audit-transactions/skills/audit-transactions/SKILL.md) | Audit Rails transaction boundaries, rollback behavior, exception handling, and external side effects. |
| [audit-http-clients](plugins/audit-http-clients/skills/audit-http-clients/SKILL.md) | Audit outbound Ruby HTTP clients for timeout budgets, retry safety, error handling, secret leakage, and failure isolation. |
| [audit-api-contracts](plugins/audit-api-contracts/skills/audit-api-contracts/SKILL.md) | Audit Rails API contracts against request behavior, serializers, OpenAPI schemas, and compatibility requirements. |
| [write-rubocop-cops](plugins/write-rubocop-cops/skills/write-rubocop-cops/SKILL.md) | Write and test custom RuboCop cops for Ruby and Rails conventions, with version-aware rules and safe autocorrection. |
| [audit-jobs](plugins/audit-jobs/skills/audit-jobs/SKILL.md) | Audit Ruby and Rails jobs for retries, duplicate effects, delivery gaps, transaction timing, concurrency, and tenant fairness. |
| [upgrade-rails](plugins/upgrade-rails/skills/upgrade-rails/SKILL.md) | Assess and upgrade Rails applications with version-specific findings, configuration previews, dependency checks, and verified incremental upgrades. |

## Installation

Register the marketplace and install the skill with your agent's CLI.

### Claude Code

```sh
claude plugin marketplace add svyatov/rails-kit
claude plugin install hyperdrive@rails-kit
```

### Codex

```sh
codex plugin marketplace add svyatov/rails-kit
codex plugin add hyperdrive@rails-kit
```

After installation, invoke `/hyperdrive:hyperdrive` in Claude Code or `$hyperdrive` in Codex, followed by your request. For another plugin, replace the name in the install command and invocation. For example, invoke `/audit-jobs:audit-jobs` or `$audit-jobs` to audit background jobs. Audits report findings first and apply fixes only when your request authorizes them.

To install the test optimization skill, replace `hyperdrive@rails-kit` with `test-performance@rails-kit` in the install command. Invoke `/test-performance:test-performance` or `$test-performance` to profile and speed up the application's test suite. Its guides cover all optimization techniques from the [Evil Martians case study](https://evilmartians.com/chronicles/railing-against-time-tools-and-techniques-that-got-us-5x-faster-results), with measured verification and test-isolation checks.

For Rails upgrades, install `upgrade-rails@rails-kit` and invoke `/upgrade-rails:upgrade-rails` or `$upgrade-rails` with the target version. The skill supports readiness assessments, configuration previews, and implementation, with source references preserved from three MIT-licensed upstream projects.

To install from a local checkout, run these commands from its root and replace `svyatov/rails-kit` with `.` in the marketplace command.

## Structure

Each `plugins/<name>/` directory contains a plugin manifest and `skills/<name>/SKILL.md`, with supporting references where needed. `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` expose the same plugins to Claude Code and Codex.

Run `ruby scripts/validate.rb` to check invocation policy, catalog consistency, frontmatter, descriptions, and local references. CI runs this check before host-specific plugin validation.

Run `ruby plugins/upgrade-rails/skills/upgrade-rails/tests/detection_test.rb` for Rails upgrade detector regressions. CI also runs both bundled detection helpers' self-tests.

Skill instructions prefer public APIs documented for the application's Rails and Ruby versions and preserve framework conventions. Article techniques, extra gems, and architecture preferences are conditional choices, not mandatory replacements for native Rails behavior. Audits require evidence and verification for proposed changes.

## License

[MIT](LICENSE)
