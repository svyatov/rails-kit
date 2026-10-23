---
name: upgrade-ruby
description: Assess and upgrade Ruby versions in Bundler and Rails applications with compatibility audits, toolchain updates, and verification.
disable-model-invocation: true
license: MIT
---

# Upgrade Ruby

## Overview

This skill upgrades a Ruby application from one major/minor Ruby version to
another — currently targeting the **Ruby 3.x → 4.0.x** jump. It runs a
breaking-change risk audit against the codebase, writes a stakeholder-ready
analysis, applies the mechanical toolchain edits (`.ruby-version`, Dockerfile,
CI, RuboCop `TargetRubyVersion`, Gemfile pins), and verifies via `bundle`,
RuboCop, type checks, and the test suite.

**This is the Ruby-interpreter upgrade.** For *Rails framework* version bumps
(6.x → 7.x → 8.x, `config.load_defaults`, railsdiff), use the
`upgrade-rails` skill instead. They are often done together. Confirm from
current official Rails documentation that the target Ruby is supported by
the application's Rails version.

**Announce at start:** "I'm using the upgrade-ruby skill to plan this Ruby upgrade."

**Breaking-change inventory:** [Ruby 4.0 checklist](references/ruby-4-0-changes.md).
It is a starting checklist, not complete coverage of every version. Current
official Ruby, RubyGems, and Bundler documentation takes precedence.

## Modes

The user may ask for one of:

- **audit-only** — stop after writing the analysis report (Phases 0–3).
- **full** (default) — audit, then apply mechanical updates, then verify.

If the target patch isn't specified, verify the latest stable in the requested
line from official release information and say which you picked. Establish the
source and target Ruby versions and the intended Bundler version separately.

## Phase 0: Verify repo + anchor target

Confirm this is a Ruby/Rails repo before doing anything:

```bash
git rev-parse --show-toplevel
test -f Gemfile && test -f Gemfile.lock
```

Bail if `Gemfile`/`Gemfile.lock` are missing. This skill operates on a Bundler
project. Read the inventory and the official release notes for every crossed
minor or major Ruby version, including the target patch. Apply the Ruby 4.0
entries only when relevant to that transition; add findings from other release
notes and from the actual RubyGems/Bundler versions in use. Record source URLs,
versions, and any unavailable sources as coverage gaps.

## Phase 1: Capture current toolchain state

Read in one parallel batch, recording each into a "Current state" table:

- `.ruby-version` (current pin)
- `Gemfile` (note any `ruby "..."` / `ruby file:` directive)
- Other existing version sources, such as `.tool-versions` or `mise.toml`,
  including files referenced by the Gemfile
- `Gemfile.lock` (`RUBY VERSION`, `BUNDLED WITH`, and key versions: rails,
  sorbet/tapioca if present, openssl, logger, ostruct, benchmark, irb, reline,
  pry, debug, nokogiri, pg, grpc, ffi, bcrypt, msgpack)
- `Dockerfile` / `*.Dockerfile` (the Ruby base-image line)
- CI config: any of `.github/workflows/*.yml`, `.gitlab-ci.yml`,
  `.gitlab/ci/**/*.yml`, `.circleci/config.yml` mentioning a Ruby version
- `.rubocop.yml` (`AllCops: TargetRubyVersion`)
- `sorbet/config` (only if the project uses Sorbet)
- `.bundle/config`, Bundler environment settings, binstubs, and deployment
  scripts, with credentials redacted

Record the active runtime with `ruby -v`, `gem --version`, and `bundle --version`.
Distinguish the running Ruby from file pins and lockfile metadata. Record the
baseline check results before making changes.

## Phase 2: Risk inventory

Sweep for every applicable inventory entry and the additional version-specific
changes identified in Phase 0. For each entry, record its applicability,
**counts and up to 5 `file:line` examples**, required runtime checks, and any
coverage gaps. Include the resolved HTTP clients and their actual adapters;
not every client uses `Net::HTTP`. Search errors are coverage gaps, not zero hits.

When subagents are available and permitted, delegate this read-only sweep using
the host's native mechanism and wait for its findings. Otherwise perform the
same sweep directly. The required coverage is identical in both paths.

## Phase 3: Write the analysis report

Write to a project-relative folder so it works in any repo:

```
docs/ruby-upgrade/<YYYY-MM-DD>/analysis.md
```
and if docs folder is not present write to:

```
tmp/ruby-upgrade/<YYYY-MM-DD>/analysis.md
```
(Use `date +%Y-%m-%d`. If the project already has a conventional analysis/report
location, prefer that and say so.)

Sections:

1. **TL;DR** — verdict (LOW / MEDIUM / HIGH risk), estimated effort, top 3 blockers.
2. **Current state** — the Phase 1 table.
3. **Risk matrix** — one row per applicable inventory entry and additional
   version-specific change, with explicit reasons for inapplicable entries:
   `# | change | exposure (counts + file:line) | risk | action`, each linking
   to the relevant official source and naming the inventory identifier, such
   as `change-01`. Only add a relative link to the installed inventory if its
   actual location is known and the link resolves from the report directory.
4. **Phased checklist** — pre-filled boxes for Phase 4.
5. **Surprises** — repo-specific findings (vendored gems, monkey-patches in
   `config/initializers/`, lock already on a newer Bundler, etc.).
6. **Open questions for the team** — type-checker (Sorbet/Steep) Ruby-4 support,
   internal Docker-registry mirroring of the target image, monitoring owner for
   fingerprint drift, gems known to lag Ruby majors (e.g. grpc).
7. **Coverage**: source and target versions, selected Bundler version, official
   release sources checked, unsearched paths, and unverified runtime behavior.

If the user asked for **audit-only**, STOP HERE and print the report path.

## Phase 4: Apply mechanical toolchain updates

Branch hygiene first: if the current branch doesn't already encode this work,
suggest a name like `upgrade-ruby-4-0-5` (prefix with the user's ticket id if
they gave one).

For version-pin edits, update only existing pins that exclude the target;
do not invent new version files. Confirmed compatibility changes may update
the existing Gemfile or configuration even when those files have no Ruby pin:

- [ ] `.ruby-version`: write the target (e.g. `4.0.5\n`).
- [ ] Other existing version sources: update the active pin and any file read
      through `ruby file:`. Preserve that indirection.
- [ ] `Gemfile`: update an explicit Ruby requirement only if it excludes the
      target; preserve compatible ranges and engine constraints. Use the
      [Ruby directive documentation](https://guides.rubygems.org/gemfile_ruby.md).
- [ ] Dockerfile(s): change `FROM ...ruby:3.X.X` → `ruby:<target>`. Preserve any
      private-registry prefix on the image (don't rewrite the registry host).
- [ ] CI YAML: update the intended runtime pins. Preserve deliberately supported
      older versions in a test matrix unless the requested support policy changes.
- [ ] `.rubocop.yml`: set `AllCops: TargetRubyVersion: <major.minor>`.
- [ ] `Gemfile`: add `gem "cgi"` if any removed CGI API is used (change-02).
      Add `gem "ostruct"` / other demoted gems ONLY if app code `require`s them
      directly and they aren't already resolved (change-03).

Activate the target Ruby through the project's existing version manager or
container before changing the lockfile. Verify its version and executable:

```bash
ruby -rrbconfig -e 'puts RUBY_DESCRIPTION; puts RbConfig.ruby'
gem --version
bundle --version
```

Stop if the runtime differs from the selected target or the intended Bundler
cannot run. File edits do not switch the active interpreter. Follow the
version-specific RubyGems/Bundler migration findings from `change-15`; preserve
the selected Bundler version instead of implicitly choosing a new major.

Then update the Ruby lock metadata under that runtime and install the bundle:

```bash
bundle update --ruby
bundle install
```

[`bundle update --ruby`](https://guides.rubygems.org/command-reference/bundle-update/)
records the current interpreter. Review the lockfile diff and keep dependency
updates limited to identified compatibility blockers. Update `BUNDLED WITH`
only when a Bundler migration is part of the selected plan.

Capture the resolution diff. If it fails on a specific gem (commonly grpc, a
Sorbet package, or a hard pre-Ruby-4 pin), STOP applying and record the failing
gem under a "Blockers" section in the report.

## Phase 5: Verify

Before running checks, confirm `bundle exec ruby -v` reports the target Ruby.
Use the application's existing test and lint commands; a plain Bundler project
does not necessarily have Rails or RuboCop. Regenerate stale type definitions
before type checking when the project requires it.

Run the relevant checks (in parallel where possible):


1. Rubocop
```bash
bundle exec rubocop         # changed files or full repo
```

2. Full test suite:

If the project uses RSpec execute:
```
bundle exec rspec --fail-fast
```
else, for a Rails project, execute:
```
bundle exec rails test
```
3. If the project is using sorbet:
```
bundle exec tapioca gem     # only if the project uses Tapioca; regenerate RBIs first
bundle exec srb tc          # only if sorbet/config exists
```

On failure: append a "Verification failures" section with the output, then
either fix-forward the obvious cases (RBI staleness, safe RuboCop autocorrects)
or stop and surface to the user. Do not claim success without showing passing
output.

If loading a native extension fails, follow the confirmed, targeted rebuild
procedure in `change-09`. Check the runtime, architecture, and extension path
before attributing the failure to stale artifacts. Ask before any operation
that discards installed-gem edits or deletes a cache.

## Phase 6: Post-merge watch (recommend, don't auto-run)

Suggest 24-hour monitoring on whatever error tracker the project uses for:

- new `ArgumentError`/backtrace fingerprints (change-10),
- a spike in `Net::HTTP` `400`/`415` responses from internal clients (change-01),
- new parse errors in any log scrapers that read Ruby internal frames.

## Hard rules

- **Keep the target runtime consistent** across its existing pins, Gemfile
  requirement, deployment images, and CI jobs. Keep intentional compatibility
  test matrices distinct from deployment pins.
- **Never auto-add `gem "ostruct"`** (or other demoted gems) unless app code
  directly `require`s them. Rails 7.1+ pins several transitively; a duplicate
  fights the lock.
- **Never enable `--zjit` in production on 4.0.x** — experimental. Keep YJIT.
- **Complete the Phase 2 sweep.** Passing tests do not establish coverage of
  untested APIs, deployment paths, native extensions, or monitoring behavior.

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Inventing new version pins | Update existing incompatible pins; allow confirmed compatibility edits in other existing files |
| Rewriting a private registry host on the Docker image | Keep the prefix; change only the tag |
| Adding `gem "cgi"`/`"ostruct"` blindly | Add only when the removed/demoted API is actually used |
| Declaring "tests pass" without output | Show the passing run |
| Confusing this with a Rails upgrade | Rails framework bump → `upgrade-rails` |
