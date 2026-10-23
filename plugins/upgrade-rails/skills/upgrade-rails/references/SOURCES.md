# Imported sources

Read this guide before consulting the imported material. The merged [upgrade-rails workflow](../SKILL.md) controls execution. Imported documents are historical reference material; their policies, release tables, examples, and tool assumptions do not override that workflow or current official Rails documentation.

## Provenance and licenses

All three sources are MIT-licensed. `../sources.json` records the full revisions, fetched timestamps, local directories, and adaptations. Supporting files retain their source directory structure. The original skill entry points are preserved as `UPSTREAM.md` for comparison, not as separately installed skills.

| Source | Pinned revision | Original skill | License notice |
| --- | --- | --- | --- |
| [Lucian Ghinda / superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby/tree/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/rails-upgrade) | `99fac3d8bee27bab20b23d4bef6fa634738a59e8` | `rails-upgrade` | [MIT, Jesse Vincent](superpowers-ruby/LICENSE) |
| [OmbuLabs.ai / FastRuby.io](https://github.com/ombulabs/claude-code_rails-upgrade-skill/tree/83e05bc7e697c20aaa1bc6be7df0eec0ef39d51e/rails-upgrade) | `83e05bc7e697c20aaa1bc6be7df0eec0ef39d51e` | `rails-upgrade` | [MIT, OmbuLabs.ai](ombulabs/LICENSE) |
| [Mario Alberto Chávez Cárdenas / Maquina](https://github.com/maquina-app/rails-upgrade-skill/tree/19e52a677c723a9f165b3611b85035e0cff37cf6) | `19e52a677c723a9f165b3611b85035e0cff37cf6` | `rails-upgrade-assistant` | [MIT, Mario Alberto Chávez Cárdenas](maquina/LICENSE.txt) |

The Superpowers source also attributes the OmbuLabs and Mario Chávez work. Their notices are preserved here alongside the Superpowers notice.

## Choose references by task

| Task | Useful source material |
| --- | --- |
| Version-specific assessment | [OmbuLabs breaking-change index](ombulabs/references/breaking-changes-by-version-reference.md), with guides from Rails 3.2 to 8.1; [Superpowers breaking changes](superpowers-ruby/references/breaking-changes.md), including unreleased material requiring fresh verification |
| Find affected code | [Superpowers detection patterns](superpowers-ruby/references/detection-patterns.md); OmbuLabs `detection-scripts/scan_patterns.rb` and its sibling pattern files for repeatable scans |
| Gem compatibility | [OmbuLabs compatibility reference](ombulabs/references/gem-compatibility-reference.md), [Superpowers gem table](superpowers-ruby/references/gem-compatibility.md), and OmbuLabs `detection-scripts/gem_limits.rb` for an initial constraint check |
| Deprecations and defaults | [OmbuLabs deprecation workflow](ombulabs/workflows/02-resolve-deprecation-warnings-workflow.md), [Superpowers defaults guide](superpowers-ruby/references/load-defaults-guide.md), and [deprecation timeline](superpowers-ruby/references/deprecation-timeline.md) |
| Dual boot and CI | [Superpowers dual-boot guide](superpowers-ruby/references/dual-boot-guide.md) and [OmbuLabs CI workflow](ombulabs/workflows/11-sync-ci-workflow.md) |
| Reports and previews | [OmbuLabs report template](ombulabs/templates/upgrade-report-template.md), [Maquina preview template](maquina/templates/app-update-preview-template.md), and [Maquina testing checklist](maquina/reference/testing-checklist.md) |

The original source workflows, examples, detection resources, templates, and guides remain beside these entry points. Read selectively. The bundled changelog-fetching shell script is preserved as source material; follow the current environment's GitHub access rules when retrieving official changelogs.

## Merge decisions and known gaps

- Fresh official version-specific documentation takes precedence over static versions, support windows, minimum Ruby tables, security advisories, configuration examples, and gem compatibility claims. Check security advice against the actual advisory and application exposure before recommending incident-response actions.
- Direct inspection and bundled detection are available without a Rails MCP server, Neovim, generated Bash scripts, or companion skills. The upstream requirement to wait for a user-run detection script is not retained.
- Dual boot and `next_rails` are optional. Upstream requirements to use `NextRails.next?` everywhere, reach an arbitrary coverage percentage, or adopt new app-template infrastructure are not retained.
- Baseline failures must remain visible. Missing tests permit only a clearly labeled partial smoke baseline. Deferred framework defaults need an explicit plan and are not automatically evidence of a failed upgrade.
- Assessments and proposed previews do not authorize application edits. Existing implementation authorization permits the scoped upgrade without a second generic approval gate. Exact update-task diffs require running the target task in an isolated app copy.
- Source coverage is incomplete: OmbuLabs advertises older releases but its bundled guides begin at 3.2, and not every hop has a pattern file. Maquina names several absent reference files. Superpowers points outside this skill to a Rails guide. Use official documentation for these gaps; do not require absent files or claim the bundle covers every Rails version.
- Four example Markdown links with the placeholder target `URL` are redirected to their original source context so local-link validation remains meaningful. The redirects are listed in `sources.json`. Original `SKILL.md` links are adjusted to the preserved `UPSTREAM.md` entry points. Other supporting content is preserved without factual rewrites.
