# Ruby 4.0 breaking-change inventory

Starting checklist for `upgrade-ruby`, adapted from the upstream skill. It
contains Ruby 4.0 changes, operational risks, and optional legacy checks. It is
not a complete list of changes for every source and target version.

Use the [Ruby 4.0.0 release notes](https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released.md)
for the 4.0 boundary. For each actual upgrade, review official notes for every
crossed minor or major version and the selected patch. Record additional
changes with their source, affected API, exposure, and verification method.
For example, check documented changes to `Binding`, `Proc#parameters`,
`Set#to_set`, and socket timeout exceptions when the application uses them.
Treat unsupported source retrieval as incomplete coverage.

Check resolved library versions as well as Ruby: default and bundled gems can
be updated independently. Preserve the application's supported platforms,
Ruby engine, and chosen Bundler version when assessing applicability.

## change-01 — `Net::HTTP` no longer sets an implicit Content-Type

**What:** POST/PUT/PATCH requests built without an explicit `Content-Type`
header no longer default to `application/x-www-form-urlencoded`. Servers that
relied on the implicit header may now reject requests with `400`/`415`.

**Detect:** Inspect `Net::HTTP` requests and the actual adapters used by client
gems. A match is a candidate: helpers such as `post_form` may already set the
header. Check the resolved client's behavior before prescribing a change.

**Risk:** High for service-to-service API integrations.

**Action:** Set `request["Content-Type"]` (or the client's equivalent) explicitly
on every mutating request.

## change-02 — CGI escape/unescape split from CGI session classes

**What:** The escaping helpers stay available via `require "cgi/escape"`
(`CGI.escape`, `CGI.unescape`, `CGI.escapeHTML`, `CGI.unescapeHTML`,
`CGI.escapeURIComponent`, `CGI.unescapeURIComponent`, `CGI.escapeElement`,
`CGI.unescapeElement`). The higher-level pieces — `CGI.parse`, `CGI::Cookie`,
`CGI::Session`, `CGI.new` — are removed from default and need the `cgi` gem.

**Detect:** `rg "CGI\.(parse|new)"`, `rg "CGI::(Cookie|Session)"` (need gem) vs
`rg "CGI\.(escape|unescape)"` (still fine).

**Risk:** Medium.

**Action:** Add `gem "cgi"` to the Gemfile if any of the removed APIs are used.

## change-03 — default gems promoted to bundled gems

**What:** Ten stdlib libraries move from *default* to *bundled* gems. They still
ship with Ruby, but a `require` at runtime now fails under Bundler unless the
gem is declared in the Gemfile (works at the bare REPL — `bundle exec` is where
it bites). Full list per
[Ruby 4.0.0 release notes](https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released.md):

| Gem | Version at 4.0.0 |
|-----|------------------|
| `ostruct` | 0.6.3 |
| `pstore` | 0.2.0 |
| `benchmark` | 0.5.0 |
| `logger` | 1.7.0 |
| `rdoc` | 7.0.2 |
| `win32ole` | 1.9.2 *(Windows only)* |
| `irb` | 1.16.0 |
| `reline` | 0.6.3 |
| `readline` | 0.0.4 |
| `fiddle` | 1.1.8 |

**Detect:** Find candidate call sites with `rg -n '\brequire\b'`, then inspect
Ruby code and match the required library against the ten names above. Handle
single or double quotes, optional parentheses, and multiline arguments; ignore
comments and documentation examples. Record unresolved dynamic require names
as coverage gaps. Check whether each library is already resolved in
Gemfile/Gemfile.lock (Rails 7.1+ pins several of these transitively).

**Risk:** Low when on Rails 7.1+; medium for plain Ruby apps. Windows CI legs
should specifically check `win32ole`.

**Action:** Add a `gem "<name>"` line ONLY for libraries the app `require`s
directly and that are not already resolved transitively. Adding a duplicate
that fights the lock is its own bug.

## change-04 — `Set` promoted to core, `SortedSet` removed

**What:** `Set` is promoted from stdlib to a core class (no `require "set"`
needed). Separately, `set/sorted_set.rb` is removed — `SortedSet` now requires
the standalone `sorted_set` gem.

**Detect:** `rg "SortedSet"` (usually zero hits); `rg 'require "set"'` (now
redundant, harmless).

**Risk:** Low.

**Action:** Use `Set` + explicit sorting, or add the `sorted_set` gem.

## change-05 — `Set#inspect` output format changed

**What:** `Set#inspect` now renders as `Set[1, 2, 3]` instead of the old
`#<Set: {1, 2, 3}>`. Any test asserting on the old literal breaks.

**Detect:** `rg "#<Set:" spec/ test/`.

**Risk:** Medium for snapshot/inline-snapshot test suites.

**Action:** Update assertions to the `Set[...]` form, or assert on contents
instead of the inspect string.

## change-06 — `Kernel#open` pipe form removed

**What:** The `open("|command")` pipe-subprocess form is removed; use
`IO.popen` explicitly.

**Detect:** Inspect `Kernel.open` and `IO` class methods receiving paths that
start with `|`, including paths built dynamically. `File.open` is a file-path
operation, not this subprocess form.

**Risk:** Low (rare), but a security-relevant pattern when present.

**Action:** Rewrite with `IO.popen`.

## change-07 — `Process::Status#&` and `#>>` removed

**What:** Bitwise operations on `Process::Status` are removed.

**Detect:** `rg "Process::Status"` then inspect for `&`/`>>` usage.

**Risk:** Low (usually zero).

**Action:** Use the dedicated predicate/accessor methods (`exitstatus`,
`signaled?`, etc.).

## change-08 — OpenSSL 4 default

**What:** Ruby 4.0 ships with a newer OpenSSL binding by default. Gems pinning
an older `openssl` may conflict.

**Detect:** Look for `openssl` pins below `4.0` in Gemfile/Gemfile.lock; also
review crypto-adjacent gems: jwt, devise, doorkeeper, ruby-saml, omniauth.

**Risk:** Low, but blocks `bundle` resolution when a hard pin exists.

**Action:** Check the resolved gem's supported Ruby and system OpenSSL versions
before changing a pin. An older pin alone does not prove incompatibility.

## change-09 — native-extension recompile required

**What:** Native extensions built for a different Ruby ABI, architecture, or
system library set can fail to load. A load failure does not prove stale cache
contents; missing libraries and unsupported gem versions can cause it too.

**Detect:** Record the load error, active Ruby executable and architecture,
resolved gem version, and extension location. Inspect Bundler's configured
installation path and the relevant container or CI cache keys.

**Risk:** Medium in Dockerized/CI environments.

**Action:** Reinstall under the verified target Ruby, preserving the lockfile.
If a rebuild is still needed:

1. Identify the affected gem and its real installation directory. Check for
   local modifications, path/git dependencies, and shared or symlinked paths.
2. Explain the exact restore or cache invalidation and obtain confirmation
   before discarding files. Prefer an isolated install path or a targeted
   rebuild over deleting the whole bundle.
3. For an unmodified, non-path gem, use the installed Bundler's supported
   targeted `bundle pristine <gem-name>` command after confirmation. It can
   discard gem edits; git gems can receive a forced checkout. Path gems require
   their own build process. See [bundle pristine](https://guides.rubygems.org/command-reference/bundle-pristine/).
4. Re-run the failing load and relevant tests. For CI or Docker, invalidate only
   the identified cache after confirmation. Never assume `vendor/bundle` is
   the active install path or automatically remove it recursively.

## change-10 — error backtrace / `ArgumentError` receiver format changed

**What:** Backtrace and some exception message formats changed. Error-grouping
in monitoring tools (Sentry, Bugsnag, Rollbar, Honeybadger, Datadog APM) may
split known issues into new fingerprints.

**Detect:** No static signal — review error-tracker init paths and any code that
parses backtrace strings.

**Risk:** Medium for observability, not for app correctness.

**Action:** Expect fingerprint churn for ~24h post-deploy; coordinate with
whoever owns alerting so the noise is expected, not paged.

## change-11 — `Ractor` API removals (`Ractor::Port`)

**What:** With the addition of `Ractor::Port`, several methods are removed:
`Ractor.yield`, `Ractor#take`, `Ractor#close_incoming`, `Ractor#close_outgoing`.

**Detect:** `rg "Ractor\.(yield|new)"`, `rg "\.(take|close_incoming|close_outgoing)\b"`
near Ractor usage.

**Risk:** Low unless the app actually uses Ractors (breaking if it does).

**Action:** Migrate the affected message-passing to `Ractor::Port`.

## change-12 - string-literal behavior and warnings

**What:** Literal behavior depends on the Ruby version, magic comments, and
runtime flags. Adding `frozen_string_literal: true` changes behavior; a missing
comment alone is not an upgrade defect. Consult the target version's
[magic-comment documentation](https://docs.ruby-lang.org/en/4.0/syntax/comments_rdoc.html#label-frozen_string_literal+Directive)
and release notes.

**Detect:** Reproduce actual warnings or failures under the selected Ruby and
the application's flags, then trace them to a mutation site.

**Risk:** Depends on observed behavior.

**Action:** Repair confirmed incompatibilities narrowly. Treat adopting frozen
string literals across files as a separate, optional change requiring approval.

## change-13 — stale URI escaping APIs

**What:** `URI.escape` / `URI.unescape` / `URI.encode` are legacy compatibility
candidates, not new Ruby 4.0 removals. Check their availability in the resolved
URI version and their actual usage before reporting an upgrade blocker.

**Detect:** `rg "URI\.(escape|unescape|encode)\b"`.

**Risk:** Low.

**Action:** If the target fails, choose a supported API for the exact encoding
context and verify output compatibility. Query-form and URI-component encoding
are not interchangeable. Unrelated modernization is optional.

## change-14 — JIT guidance (ZJIT experimental, RJIT removed)

**What:** ZJIT is introduced as an experimental method-based JIT (its build
requires Rust 1.85.0+). RJIT is removed (moved to an external repo). YJIT
remains the production-safe JIT.

**Action:** Do NOT enable `--zjit` in production on 4.0.x — keep YJIT. If a
Docker/CI image builds Ruby from source with ZJIT, ensure Rust ≥ 1.85.0.

## Quick reference

| # | Change | Risk | Primary detection |
|---|--------|------|-------------------|
| 01 | `Net::HTTP` implicit Content-Type removed | High | grep `Net::HTTP::(Post\|Put\|Patch)` |
| 02 | `CGI.parse`/`CGI::Cookie`/`CGI::Session` removed | Medium | grep `CGI.parse`; add `gem "cgi"` |
| 03 | default gems demoted | Low–Med | inspect require arguments and the resolved bundle |
| 05 | `Set#inspect` format | Medium | grep `#<Set:` in tests |
| 09 | native-extension compatibility | Medium | inspect load error and runtime; confirm targeted rebuild |
| 10 | backtrace/fingerprint drift | Medium | monitor post-deploy |
| 08 | OpenSSL 4 default | Low | grep `openssl.*< 4` in lock |
| 15 | RubyGems/Bundler migration | Context-dependent | versions, install scripts, sources, config, lockfile |

## change-15 - RubyGems and Bundler versions

Ruby 4.0 ships RubyGems/Bundler 4, but a project's selected versions may differ.
Check `gem --version`, `bundle --version`, `BUNDLED WITH`, and CI/container
setup. Use the [official migration guide](https://blog.rubygems.org/2025/12/03/upgrade-to-rubygems-bundler-4.html)
when crossing this boundary; review other versions' notes for other upgrades.

**Detect:** Inspect scripts and config for removed persistent install flags
(`--path`, `--without`, `--deployment`, `--frozen`, and others), removed commands
such as `bundle inject` or `bundle viz`, ambiguous global Gemfile sources, and
removed RubyGems/Bundler APIs. Review lockfile and cache changes too.

**Action:** Move affected install settings to explicit local configuration or
CI environment variables. Keep source assignments unambiguous without changing
where existing gems come from. Use `bundle install` explicitly. Explain
expected lockfile format/checksum changes; do not treat these as gem upgrades.
Choose and record the Bundler version deliberately, then verify installation
in the actual development and deployment contexts. Avoid global config edits.
