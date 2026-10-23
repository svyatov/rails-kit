# Sources and audit scope

The [upgrade workflow](../SKILL.md) combines assessment, incremental upgrades, configuration previews, and verification from the three MIT-licensed sources below. The package retains their licenses and pinned provenance instead of duplicate tutorials and workflows.

| Source | Imported revision | License notice |
| --- | --- | --- |
| [Lucian Ghinda / superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby/tree/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/rails-upgrade) | `99fac3d8bee27bab20b23d4bef6fa634738a59e8` | [MIT, Jesse Vincent](superpowers-ruby/LICENSE) |
| [OmbuLabs.ai / FastRuby.io](https://github.com/ombulabs/claude-code_rails-upgrade-skill/tree/83e05bc7e697c20aaa1bc6be7df0eec0ef39d51e/rails-upgrade) | `83e05bc7e697c20aaa1bc6be7df0eec0ef39d51e` | [MIT, OmbuLabs.ai](ombulabs/LICENSE) |
| [Mario Alberto Chávez Cárdenas / Maquina](https://github.com/maquina-app/rails-upgrade-skill/tree/19e52a677c723a9f165b3611b85035e0cff37cf6) | `19e52a677c723a9f165b3611b85035e0cff37cf6` | [MIT, Mario Alberto Chávez Cárdenas](maquina/LICENSE.txt) |

The Superpowers source also credits the OmbuLabs and Mario Chávez work. Full snapshots remain available through the pinned URLs and import commit `c82378a`. [sources.json](../sources.json) records the import and subsequent pruning decisions.

## Maintained references

- [Operations](operations.md): baseline checks, optional dual boot, framework defaults, and configuration previews.
- [Reports](reports.md): one upgrade report and one configuration-preview format.
- `ombulabs/version-guides/`: short per-hop notes derived from the selected rules, with official evidence. These cover the release sequence from Rails 3.2 to 8.1.
- `ombulabs/detection-scripts/`: the scanner, lockfile helper, and one curated pattern set. Markdown, JSON, and `--explain` scan output includes official sources and verification dates.

## Detection audit, 2026-10-23

The initial OmbuLabs set contained 274 rules. The current set contains 55 selected candidates, including corrected or moved rules. Every retained rule cites the Rails source, release changelog, or official upgrade guide supporting its version-specific claim. Evidence uses release tags rather than the moving Rails main branch. Recheck the exact target patch before applying a fix.

The audit removed duplicate advice, optional choices presented as requirements, and application-specific or gem-specific claims that were not verified. Removal does not mean every omitted rule was false. Retired identifiers are recorded by source version in `sources.json` for investigation at their original revision.

| Case | Current treatment |
| --- | --- |
| Jobs in transactions | Inspect effective configuration and the adapter; preserve asynchronous execution and test commits, rollbacks, and enqueue failures. |
| `serialize` | Detect the removed positional argument. Distinguish `coder:` from `type:`; a configured default coder can support a bare declaration. |
| `fixture_path` | Identify the Rails 7.2 removal and check the owning test framework before replacing it. |
| `query_constraints` | Flag association options, not the distinct model-level declaration. |
| Sidekiq | Detect a configured adapter and verify which implementation is loaded. Rails 8.1 deprecates its own adapter, not the use of Sidekiq. |
| Numeric column helpers | Distinguish unsigned float/decimal helpers from unsigned integer options. |
| Infrastructure | Existing Sprockets, Redis, queues, deployment tools, and pool settings are not automatic upgrade failures. |

## Limits

This is a deliberately partial detector, not a full list of Rails changes or a Ruby parser. Patterns can match comments or unrelated methods and miss computed calls, uncommon syntax, configuration interactions, and runtime-only failures. Missing paths are reported as unscanned; suppressed matches are not proof of safety. Discovery, read, and matching errors are reported as partial coverage with affected paths. Successful findings remain visible, and only successfully read and matched files count as scanned. Use official guides and application tests for every hop, including changes outside this set.

The lockfile helper checks selected declared constraints, not every dependency or exact-patch restriction. Verify resolver results and upstream compatibility separately. Neither helper authorizes application edits or decides whether a fix can ship before the Rails bump.
