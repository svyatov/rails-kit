---
name: optimize-tests
description: "Profile and speed up Rails tests with TestProf, targeted side-effect controls, lean factories, and safely shared fixtures."
license: MIT
disable-model-invocation: true
compatibility: Requires a Rails application, Ruby, Bundler, and a runnable test database. Examples use RSpec and FactoryBot; check TestProf support for other runners and factory libraries.
---

# Optimize tests

Find and remove repeated work while preserving what the tests prove. This is an original workflow extracted from the Evil Martians case study, with API details checked against TestProf documentation. See [sources and coverage](references/sources.md).

Keep the application's existing test runner, native fixtures, and Rails isolation conventions. TestProf helpers are targeted options after profiling, not a reason to migrate Minitest to RSpec, replace working fixtures, or weaken model behavior. For a profile-only request, stop with measurements and proposed fixes instead of changing tests or dependencies.

## 1. Establish a comparable baseline

Read the application's instructions, test runner, helpers, factory definitions, database configuration, CI commands, and locked gem versions. Identify the requested scope and existing profiling tools before changing dependencies. Confirm that the test process uses its intended test databases, including each worker's database.

Record the revision, exact command, selected tests, seed, example and failure counts, wall time, Ruby version, worker count, and machine or CI runner. Separate test execution from queue time, dependency installation, and application boot. Resolve existing failures or record them separately before attributing a change to optimization.

For a dirty or concurrently edited checkout, use a fixed snapshot or record content hashes of relevant tracked and untracked inputs before and after each run. Reject runs whose inputs changed during execution, and confirm that before/after runs select the same examples.

Use the same conditions for before/after measurements. Repeat timings enough to distinguish a useful change from ordinary variation; retain individual runs or report a median. A sampled profile can locate a problem, but is not a whole-suite benchmark.

Done when the scope, baseline, and conditions for comparison are recorded.

## 2. Locate the expensive repeated work

Read [profiling](references/profiling.md) for setup, StackProf, FactoryProf, sampling, and RSpecDissect commands. Start with a broad call-stack profile, then use the profiler that answers the observed bottleneck. Keep profiler runs separate from uninstrumented timing runs.

Rank candidates by total avoidable time across the requested suite and expected implementation cost. Prefer a commonly used slow factory or callback over an isolated example with little aggregate cost. Stop investigating marginal savings when they do not justify the work.

Done when each proposed change has an observed cost, a likely cause, and a verification command.

## 3. Apply the smallest relevant optimization

Load only the relevant guide:

| Profile evidence | Guide |
| --- | --- |
| Repeated history, indexing, logging, or external-service work | [Optional side effects](references/side-effects.md) |
| Factories create unnecessary or repeated associations | [Factory optimization](references/factories.md) |
| Repeated setup dominates examples, or suite-wide reference data is recreated | [Shared fixtures and isolation](references/shared-fixtures.md) |

Apply one cause-level change at a time. Keep assertions, required model relationships, and behavior coverage intact. Fix tests to state their real prerequisites, not to tolerate invalid data. Preserve the application's production behavior when adding test controls.

Done when the focused tests pass and the new profile shows that the targeted work decreased.

## 4. Verify speed and independence

Run affected examples alone, with their neighboring groups, and in randomized order using recorded seeds. Exercise both real and fake side-effect paths and any examples that need distinct users, tenants, or an empty database. For fixture changes, verify database cleanup, Ruby object state, and relevant parallel-worker behavior.

Run the requested suite with its normal command and profiling disabled. Compare example counts, failures, and repeated timings against the baseline. For global factories or test-helper changes, include the full suite; a single fast file is insufficient evidence. Check the real CI job when CI performance is the requested outcome and access permits it.

Keep a change only when correctness holds and the measurement supports it. If full-suite or CI verification is unavailable, report that limit rather than extrapolating a local result.

## 5. Report the measured outcome

Provide the before/after commands and timings, scope and example counts, removed work, and remaining bottlenecks. Distinguish profiled measurements from normal runtime. Give the command that reproduces the result and identify any remaining isolation checks. The case study's fivefold result is not a promised outcome for another application.
