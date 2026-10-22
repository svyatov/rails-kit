# Job correctness and delivery

## Arguments and lookup timing

Native Sidekiq arguments must survive JSON serialization; prefer small identifiers and JSON-compatible values. Symbols, arbitrary Ruby objects, and keyword-argument assumptions can break that contract. Test a real serialization round trip rather than only invoking `perform` directly.

Active Job supports its own serializers and GlobalID, even when backed by Sidekiq. Do not impose native Sidekiq's raw argument restriction on its Active Job wrapper. A deleted GlobalID record can fail during deserialization before `perform`. Decide whether missing records should be discarded, retried, or reported according to the job's purpose.

Avoid capturing stale or sensitive state unnecessarily. Verify tenant identity and authorization requirements at execution time where the domain needs them, and avoid logging sensitive arguments.

## Transactions and enqueue

Map the actual database connection and enqueue mechanism. Active Job's `enqueue_after_transaction_commit` defers enqueueing until successful commit, with behavior depending on the installed Rails/adapter versions. It does not make the database commit and a subsequent external enqueue atomic.

Solid Queue can participate in an application transaction only with the appropriate same-database connection arrangement. Its ordinary separate queue database cannot provide that atomicity. Do not infer it from both databases running on the same server.

Native Sidekiq transactional push has its own setup and limitations; inspect the installed version and configuration rather than applying Active Job settings to it. In particular, verify multi-database connection behavior and bulk-enqueue support.

An after-commit hook solves an ordering problem. A failure or crash before a later queue push can still lose the intended work. If durable delivery is a requirement, identify the missing recovery mechanism and propose a proportionate design, such as existing reconciliation or an outbox. Do not install a new delivery subsystem during a report-only audit.

## Duplicates and partial effects

Assume duplicate execution is possible unless the complete system proves otherwise. Inspect every effect, not only a final completed flag. A crash after payment succeeds but before the flag is written can repeat the payment. A lock or unique queue entry is not proof of exactly-once external effects.

Use stable logical-operation identifiers and provider-supported deduplication where available. Verify the provider's key scope, lifetime, and payload contract. Preserve the same identity across job retries. For long jobs, inspect checkpoints and resumability so a retry neither skips unfinished work nor repeats irreversible completed work.

## Retry and recovery policy

Inventory Active Job `retry_on`/`discard_on`, processor retries, and retries inside clients. Compute combined attempts and elapsed time, not just one layer's count. Distinguish transient failures from permanent input or business errors. A rescue that reports but swallows an exception can mark incomplete work successful.

Sidekiq's `retry: false` and `retry: 0` differ: the former discards a failure; the latter skips retries but retains it in the Dead set. Confirm version and local overrides. Check exhaustion reporting, retention, and the authorized recovery process.

Do not promise universal at-least-once delivery. Native open-source Sidekiq's fetch removes work from Redis before completion, so a process crash can lose in-flight work. Pro's recoverable fetch behavior is different and must be enabled. Duplicate-execution safety and durable delivery are separate requirements.

Solid Queue uses Active Job retry policy for ordinary job errors. Process-death failures are recorded outside the vanished process and cannot be caught by that job's `retry_on` or `rescue_from`. Inspect operational recovery separately. Never claim that an inline test proves crash recovery.
