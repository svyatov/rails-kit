<p align="center">
  <img src="docs/assets/logo.png" alt="Rails Kit: a ruby inside a railway tunnel" width="420" height="280">
</p>

<p align="center"><strong>Rails skills for Claude Code and Codex: audit applications, optimize tests, and plan upgrades with evidence.</strong></p>

<p align="center">
  <a href="https://github.com/svyatov/rails-kit/actions/workflows/validate.yml"><img alt="Validation" src="https://github.com/svyatov/rails-kit/actions/workflows/validate.yml/badge.svg"></a>
  <a href="#claude-code"><img alt="Claude Code" src="https://img.shields.io/badge/Claude_Code-plugin-D97757"></a>
  <a href="#codex"><img alt="Codex" src="https://img.shields.io/badge/Codex-plugin-111827"></a>
  <a href="LICENSE"><img alt="MIT license" src="https://img.shields.io/badge/license-MIT-blue"></a>
</p>

<p align="center">
  <a href="#installation">Install</a> ·
  <a href="#skills">Skills</a> ·
  <a href="#usage">Usage</a> ·
  <a href="CONTRIBUTING.md">Contribute</a> ·
  <a href="CHANGELOG.md">Changelog</a>
</p>

- **Install the kit once.** One plugin includes all 11 skills for Claude Code and Codex.
- **Run it when you choose.** Every skill requires explicit invocation. Audits report findings first; fixes require your authorization.
- **Keep Rails conventions.** Skills use version-specific Rails and Ruby documentation, identify optional tools, and require evidence for proposed changes.

## Installation

Register the marketplace and install Rails Kit with your agent's CLI. Every skill in the [catalog](#skills) is included.

### Claude Code

```sh
claude plugin marketplace add svyatov/rails-kit
claude plugin install rails-kit@rails-kit
```

### Codex

```sh
codex plugin marketplace add svyatov/rails-kit
codex plugin add rails-kit@rails-kit
```

To install from a local checkout, run the marketplace command from its root with `.` instead of `svyatov/rails-kit`. Start a new agent session after installation.

### Migrating from individual plugins

Earlier versions installed each skill as a separate plugin. Claude Code uses the catalog's rename history to migrate old plugin settings to `rails-kit`. Codex requires manual migration.

1. In Codex, uninstall each old Rails Kit plugin you installed with `codex plugin remove <old-plugin>@rails-kit`, replacing `<old-plugin>` with its installed name, such as `audit-jobs`, `setup-hyperdrive`, or `optimize-tests`. Older installations may use `hyperdrive` or `test-performance`. Claude Code users can skip this step.
2. For a Git-backed marketplace, refresh it with `claude plugin marketplace update rails-kit` or `codex plugin marketplace upgrade rails-kit`. If you registered a local checkout, update that checkout instead. Then install `rails-kit@rails-kit` with the command above. Claude Code users who installed from Git or a URL also need this one-time install to populate the renamed plugin's cache.
3. Start a new session and invoke skills with the `rails-kit` namespace. For example, replace `/audit-jobs:audit-jobs` with `/rails-kit:audit-jobs` in Claude Code, and use `$rails-kit:audit-jobs` in Codex. Update saved prompts that use old plugin names.

## Usage

Open your Rails project in your agent and invoke a skill with a request. For example:

**Claude Code**

```text
/rails-kit:audit-jobs Audit app/jobs for retries and duplicate side effects. Report findings before making changes.
```

**Codex**

```text
$rails-kit:audit-jobs Audit app/jobs for retries and duplicate side effects. Report findings before making changes.
```

The invocation format is `/rails-kit:<skill-name>` in Claude Code and `$rails-kit:<skill-name>` in Codex. Choose any skill below; no additional plugin installation is needed.

## Skills

| Skill | Description |
| --- | --- |
| [setup-hyperdrive](skills/setup-hyperdrive/SKILL.md) | Set up and maintain Rails Hyperdrive in a Rails project: development-only gems, companion skills, MCP access, and safe content sync. |
| [optimize-tests](skills/optimize-tests/SKILL.md) | Profile and speed up Rails tests with TestProf, targeted side-effect controls, lean factories, and safely shared fixtures. |
| [audit-active-record-concurrency](skills/audit-active-record-concurrency/SKILL.md) | Audit concurrent Active Record writes for duplicate records, lost updates, and broken database invariants. |
| [audit-n-plus-one](skills/audit-n-plus-one/SKILL.md) | Audit Rails query growth, locate N+1 queries, and verify loading or batching fixes with regression coverage. |
| [audit-transactions](skills/audit-transactions/SKILL.md) | Audit Rails transaction boundaries, rollback behavior, exception handling, and external side effects. |
| [audit-http-clients](skills/audit-http-clients/SKILL.md) | Audit outbound Ruby HTTP clients for timeout budgets, retry safety, error handling, secret leakage, and failure isolation. |
| [audit-api-contracts](skills/audit-api-contracts/SKILL.md) | Audit Rails API contracts against request behavior, serializers, OpenAPI schemas, and compatibility requirements. |
| [write-rubocop-cops](skills/write-rubocop-cops/SKILL.md) | Write and test custom RuboCop cops for Ruby and Rails conventions, with version-aware rules and safe autocorrection. |
| [audit-jobs](skills/audit-jobs/SKILL.md) | Audit Ruby and Rails jobs for retries, duplicate effects, delivery gaps, transaction timing, concurrency, and tenant fairness. |
| [upgrade-rails](skills/upgrade-rails/SKILL.md) | Assess and upgrade Rails applications with version-specific findings, configuration previews, dependency checks, and verified incremental upgrades. |
| [upgrade-ruby](skills/upgrade-ruby/SKILL.md) | Assess and upgrade Ruby versions in Bundler and Rails applications with compatibility audits, toolchain updates, and verification. |

Invoke `/rails-kit:optimize-tests` or `$rails-kit:optimize-tests` to profile and speed up the application's test suite. Its guides cover all optimization techniques from the [Evil Martians case study](https://evilmartians.com/chronicles/railing-against-time-tools-and-techniques-that-got-us-5x-faster-results), with measured verification and test-isolation checks.

For Rails upgrades, invoke `/rails-kit:upgrade-rails` or `$rails-kit:upgrade-rails` with the target version. The skill supports readiness assessments, configuration previews, and implementation, with source references preserved from three MIT-licensed upstream projects.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for repository layout, skill requirements, and validation commands. Bug reports, skill proposals, and questions go to [GitHub Issues](https://github.com/svyatov/rails-kit/issues).

## Sources and license

Rails Kit is [MIT licensed](LICENSE). Individual skills keep their source references alongside the instructions. The Rails upgrade skill also preserves [upstream provenance and licenses](skills/upgrade-rails/sources.json).

Rails Kit is an independent project, not an official Rails, Anthropic, or OpenAI product.
