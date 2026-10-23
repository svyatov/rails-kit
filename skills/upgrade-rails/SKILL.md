---
name: upgrade-rails
description: Assess and upgrade Rails applications with version-specific findings, configuration previews, dependency checks, and verified incremental upgrades.
disable-model-invocation: true
license: MIT
---

# Upgrade Rails

Assess readiness, plan an upgrade, preview configuration changes, or carry out an authorized upgrade. Start with the requested mode. Analysis, next-version questions, supplied findings, and preview-only requests do not authorize application changes. An implementation request authorizes the steps needed for that upgrade; ask only for missing decisions or actions outside that scope.

## Evidence and references

Treat the application's conventions and official documentation for its exact current and target versions as authoritative. Try the documentation site's `llms.txt` or `llms-full.txt` first, then HTML. Read the relevant sections of the [Rails upgrading guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html), the target release notes, and component changelogs at the matching Rails tag. Verify Ruby requirements against that release's gemspec and the [Ruby maintenance branches](https://www.ruby-lang.org/en/downloads/branches/). Resolve current patch releases and security status live; never infer them from a bundled version table.

Read [the source guide](references/SOURCES.md) for provenance, rule coverage, and known gaps. Load only material relevant to the current hop. No companion skill, MCP server, editor integration, or extra gem is required.

## 1. Establish scope and the baseline

Read `Gemfile`, lockfiles, Ruby version files, `config/application.rb`, framework-default initializers, test commands, and CI/deployment configuration. Identify the locked Rails version, actual runtime Ruby, `config.load_defaults`, target version, database, asset pipeline, job backend, engines, and any existing dual-boot setup. Preserve unrelated work and local instructions. Ask for the target if it cannot be inferred from the request.

Plan consecutive Rails release-series hops, including major boundaries, with the latest compatible patch in each selected series. Resolve any Ruby prerequisite separately, choosing a version compatible with the current and next Rails releases; do not assume the newest Ruby runs an old Rails app. Record unsupported intermediate versions and their limited use as migration steps.

Before changing dependencies or behavior, run the application's existing test commands and record results and deprecations. Prefer its documented runner over guessed RSpec or Minitest commands. Run checks against test services and databases. If the baseline fails, investigate and distinguish existing failures from upgrade failures; do not claim a passing baseline or silently bypass it. Agree on unresolved baseline failures before implementation proceeds.

If no runnable tests exist, record that limitation and use boot, routes, database migration status, relevant build checks, and representative local requests as a partial baseline. Do not create or migrate a database as an incidental readiness check. Missing services and credentials mean unverified checks, not passing checks. See [baseline checks](references/operations.md#baseline-checks), adapting commands to the app.

Completion: report the observed environment, target patch and its source, hop sequence, baseline, and unknowns.

## 2. Assess the next hop

Read the official upgrade notes and changelogs for this hop. Use the version guides and patterns linked in [the source guide](references/SOURCES.md) to find additional candidates. Search application code, configuration, engines, custom tasks, and relevant initializers. Inspect each matching call site and confirm that the change applies under the app's actual configuration. Regex matches are candidates; no matches do not prove compatibility.

For repeatable detection, run the bundled scanner from the application root, substituting the installed skill's absolute path and the target release series:

```sh
ruby <skill-dir>/references/ombulabs/detection-scripts/scan_patterns.rb --target X.Y
ruby <skill-dir>/references/ombulabs/detection-scripts/gem_limits.rb --target X.Y
```

These use Ruby's standard library. The scanner contains 55 selected rules, each with official sources and a verification date. It is not an exhaustive upgrade audit: report skipped paths, suppressed results, and behavior outside the rules. Discovery, read, or matching errors mean partial coverage, not a clean scan; include the affected paths and retained findings in the report. Read the linked source for the exact selected patch before applying a candidate. The gem-limit helper is a first pass over declared lockfile constraints, not a dependency resolver or runtime compatibility proof. Verify exact patch constraints, source revisions, Ruby requirements, and maintained compatible versions in each affected dependency's upstream documentation before changing it. Scope bundle updates to the required dependency set and inspect all lockfile changes.

Capture deprecations using supported APIs for the current Rails version and exercise the paths that emit them. Prefer fixes that work on the current and next versions. Separate framework removals, application-specific failures, optional new defaults, and unrelated modernization. Preserve existing asset, cache, queue, and deployment choices unless compatibility or the request requires a change.

Completion: every finding has a file and line, observed code or runtime evidence, an authoritative version-specific source, impact, and proposed fix. Clearly label unconfirmed candidates and coverage gaps.

## 3. Prepare the report and configuration preview

Before implementation, present a report containing the environment and baseline, planned hops, confirmed blockers, dependency changes, deprecations, configuration changes, defaults strategy, verification plan, and rollback limits. Distinguish fixes that must precede the version bump from work that must run on the target bundle. Use [the report template](references/reports.md#upgrade-report) as a checklist, adapting its sections to the request.

Compare the app's real configuration with the target generator output. [RailsDiff](https://railsdiff.org/) or its [generated-app repository](https://github.com/railsdiff/rails-new-output) can suggest changed templates when both exact tags exist. Treat this as a template comparison, not the app's actual update result. If tags or network access are unavailable, report the gap and consult the target's official generator source.

For an exact `app:update` preview, use a disposable copy of the app with the target bundle, run the task there, and inspect the resulting diff against the original. Otherwise label the preview as proposed. Do not run the task in the working app for a preview-only request. Preserve customized configuration and classify changes as required, optional, or needing a product decision. The [preview template](references/reports.md#configuration-preview) provides a compact structure.

Completion: deliver findings and preview without invented diffs, line numbers, timings, or accuracy estimates. For assessment-only requests, stop here. For an authorized implementation, proceed within the agreed scope; if only assessment was authorized, obtain implementation approval first.

## 4. Implement and verify one hop

Use an isolated branch and apply compatibility fixes in small, reviewable steps. If the current series needs a patch update first, verify it separately against the baseline. Update Rails and necessary dependencies, inspect resolution changes, and check boot before addressing application failures. Keep Ruby upgrades separate when the compatibility overlap allows it.

Dual boot is optional: use it when the team needs to keep shipping on the current Rails release or when comparison materially reduces upgrade risk. Preserve an existing setup. Before adding `next_rails`, inspect its upstream installation instructions and compatibility; [dual-boot guidance](references/operations.md#dual-boot) explains the checks. Test both bundles when dual boot is used. Choose compatibility guards appropriate to the app rather than mandating a gem-specific predicate everywhere.

Run `bin/rails app:update` with the target bundle and review each diff, or apply the reviewed configuration changes manually. Do not force-overwrite customized files. Keep the current `config.load_defaults` while first proving the new Rails version works, then enable new defaults incrementally with focused tests. Existing default initializers are evidence of deferred choices, not automatic blockers. Track each deferred default, its risk, and the reason it remains deferred. See [framework defaults](references/operations.md#framework-defaults), verifying each setting against official documentation. Change `config.load_defaults` only after validating the settings it enables; remove a transition initializer only when its remaining settings have been accounted for.

After each meaningful change, run focused checks. Before completing the hop, run the full baseline suite, boot and eager-load checks where supported, relevant assets/builds, and representative application flows. Include affected jobs, serialization, sessions/cookies, authentication, and database behavior. Align CI and deployment Ruby versions, bundles, asset commands, and services. Explain backward compatibility for data, encrypted values, caches, and queued payloads before proposing a rolling deployment or rollback; a Git revert does not undo a data-format change.

Completion: the current hop's checks pass, observed failures are resolved, and any unverified behavior or deferred defaults are explicitly reported. Do not advance to the next hop with unresolved upgrade regressions. Do not publish, deploy, or remove dual-boot support unless the request includes that action.

## 5. Handoff or continue

For each completed hop, report actual Rails and Ruby versions, commands and results, remaining deprecations, deferred defaults, manual checks, and rollback constraints. Continue the same assessment and verification loop for each authorized hop. Final status must distinguish implemented work, passing checks, checks not run, and deployment status. Never call an upgrade complete solely because dependency resolution or a pattern scan succeeded.

## Attribution

Merged from Lucian Ghinda's `superpowers-ruby`, OmbuLabs.ai / FastRuby.io's `claude-code_rails-upgrade-skill`, and Mario Alberto Chávez Cárdenas's `rails-upgrade-skill`, all under MIT. Exact revisions, preserved license notices, and import adaptations are recorded in [the source guide](references/SOURCES.md) and `sources.json`.
