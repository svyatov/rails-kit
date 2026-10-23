# Optional side effects

Use this guide when a profile shows significant repeated work in features such as audit history, search indexing, logging, or external-service adapters.

## Establish the behavior boundary

Identify which examples require the real effect and which only need the primary operation to succeed. Inspect callers and existing feature tests before changing the default. A callback that maintains domain data or enforces an invariant is required behavior, even if bypassing it makes tests faster.

Prefer the feature's existing testing interface or the application's service adapter. If none exists, introduce the smallest feature-specific test control. The article uses a `Testing` interface with `fake!`, `real!`, and `fake?`, plus RSpec metadata to select examples that need the real callback.

Production must retain real behavior by default. Enable a fake only in test setup. Keep the control at the optional effect's boundary, so primary writes, validations, and domain logic still execute. Avoid removing callbacks globally with `skip_callback` or changing behavior merely because `Rails.env.test?` is true.

## Scope and reset the mode

Use a clear metadata tag, such as `:real_search_index`, for examples that need the effect. Apply the mode before their setup runs and restore the prior mode in an `ensure` block. Confirm that nested contexts and exceptions cannot leak state into another example.

A process-global flag is unsafe when examples in one process run concurrently. Use the adapter's scoped interface or isolation compatible with the runner. Thread-local state alone does not control work executed on another thread. Test both tagged and untagged examples in randomized order.

Retain integration tests that invoke the real callback or adapter and assert its effect. Add a focused regression test if the changed boundary lacks one. A faster green suite with no test of the real path has lost evidence.

## Logging and remote work

If log formatting or writing is measurably expensive, use test-only logger configuration that reduces that work while retaining useful failure diagnostics. Restore logging for examples that assert log behavior. Do not remove application log statements to improve a test benchmark.

For remote calls, reuse deterministic test adapters, stubs, or recorded responses consistent with the existing suite. Preserve request-contract and failure-path coverage. A local fake does not verify the external integration, so report those checks separately.

Rerun the call-stack profile and the normal suite. Count the remaining real-effect executions where possible to show that the change removed only unnecessary work.
