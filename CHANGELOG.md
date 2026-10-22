# Changelog

## Unreleased

### Added

- Add `audit-transactions` 1.0.0: Audit Rails transaction boundaries, rollback behavior, exception handling, and external side effects.

- Add `audit-n-plus-one` 1.0.0: Audit Rails query growth, locate N+1 queries, and verify loading or batching fixes with regression coverage.

- Add `audit-active-record-concurrency` 1.0.0: Audit concurrent Active Record writes for duplicate records, lost updates, and broken database invariants.

- Add `test-performance` 1.0.0, an original Rails test optimization workflow based on Evil Martians' case study, with profiling, side-effect controls, factory optimization, and shared-fixture guides.
- Initialize Rails Kit with Claude Code and Codex marketplace catalogs.
- Add `hyperdrive` 1.0.0 from Agent Toolkit's `rails-hyperdrive`, including configuration and source references.
- Validate the marketplace and every plugin in CI on pull requests and pushes to `main`.

### Fixed

- Preserve legacy Hyperdrive content preferences before bundle changes or synchronization.
- Link to the Markdown version of the Codex MCP documentation.
- Use `rails-kit` as the marketplace name in both catalogs and installation instructions.
