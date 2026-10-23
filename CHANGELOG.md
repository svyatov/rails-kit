# Changelog

## Unreleased

### Changed

- Rename the `hyperdrive` plugin and skill to `setup-hyperdrive`, and `test-performance` to `optimize-tests`. Update installation and invocation examples to use the new names.

- Harden `upgrade-ruby` with active-interpreter and Gemfile checks, version-specific Ruby/Bundler coverage, portable audit reports, and confirmed native-extension rebuilds. Cover compatibility edits in files without Ruby pins and common require syntax, and use available Markdown documentation sources.

- Refresh the README with the Rails Kit logo, validation and agent badges, quick navigation, and installation-first usage examples.

- Curate `upgrade-rails` to one set of 55 detection rules with official source links, concise hop notes, and shared report/operation references. Remove duplicate imports and correct job timing, serialization, fixture paths, association constraints, and adapter detection.

- Use Markdown article sources in the seven audit and cop-authoring skills to reduce retrieval overhead.
- Strengthen current Rails conventions in every workflow, including Executor-wrapped concurrency tests, enqueue-failure checks, Strong Parameters and CSRF protection, native test isolation, and version-aware cop policies.
- Require explicit invocation for every skill in Claude Code and Codex, with matching human-facing descriptions and invocation examples.
- Enforce explicit invocation and skill packaging contracts with a dependency-free Ruby validator in CI.

### Added

- Add `upgrade-ruby` 1.0.0: Import the Ruby interpreter upgrade workflow and Ruby 4.0 compatibility inventory from [lucianghinda/superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby) (MIT), with explicit invocation, source provenance, and preserved license attribution.

- Add contribution guidance and issue and pull request templates for skill reports and proposals.

- Add `upgrade-rails` 1.0.0: Merge the MIT-licensed Rails upgrade skills from [lucianghinda/superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby), [ombulabs/claude-code_rails-upgrade-skill](https://github.com/ombulabs/claude-code_rails-upgrade-skill), and [maquina-app/rails-upgrade-skill](https://github.com/maquina-app/rails-upgrade-skill). Include version-aware assessments, configuration previews, incremental implementation, source provenance, and preserved supporting files.

- Add `audit-jobs` 1.0.0: Audit Ruby and Rails jobs for retries, duplicate effects, delivery gaps, transaction timing, concurrency, and tenant fairness.

- Add `write-rubocop-cops` 1.0.0: Write and test custom RuboCop cops for Ruby and Rails conventions, with version-aware rules and safe autocorrection.

- Add `audit-api-contracts` 1.0.0: Audit Rails API contracts against request behavior, serializers, OpenAPI schemas, and compatibility requirements.

- Add `audit-http-clients` 1.0.0: Audit outbound Ruby HTTP clients for timeout budgets, retry safety, error handling, secret leakage, and failure isolation.

- Add `audit-transactions` 1.0.0: Audit Rails transaction boundaries, rollback behavior, exception handling, and external side effects.

- Add `audit-n-plus-one` 1.0.0: Audit Rails query growth, locate N+1 queries, and verify loading or batching fixes with regression coverage.

- Add `audit-active-record-concurrency` 1.0.0: Audit concurrent Active Record writes for duplicate records, lost updates, and broken database invariants.

- Add `optimize-tests` 1.0.0, an original Rails test optimization workflow based on Evil Martians' case study, with profiling, side-effect controls, factory optimization, and shared-fixture guides.
- Initialize Rails Kit with Claude Code and Codex marketplace catalogs.
- Add `setup-hyperdrive` 1.0.0 from Agent Toolkit's `rails-hyperdrive`, including configuration and source references.
- Validate the marketplace and every plugin in CI on pull requests and pushes to `main`.

### Fixed

- Pin validation CI to Ubuntu 24.04 and configure Git's initial branch before checkout to remove runner-migration notices and default-branch hints.

- Add a shared Rails Kit icon to every plugin and validate its presence and dimensions to eliminate missing-icon warnings.

- Align upgrade helper usage examples with the installed skill layout and current pattern coverage.

- Report discovery, read, and matching failures as partial upgrade-scan coverage instead of clean results, retaining successful findings and exposing affected paths in Markdown and JSON.

- Preserve existing upgrade-scan reports on failure, write explanations to the requested output, and reject output paths that would overwrite scan inputs.

- Preserve legacy Hyperdrive content preferences before bundle changes or synchronization.
- Link to the Markdown version of the Codex MCP documentation.
- Use `rails-kit` as the marketplace name in both catalogs and installation instructions.
