# Race reproduction and correction

## Reproduce the operation, not just the final assertion

Use the application's runner and a disposable database. Commit setup data before opening competing connections. Size the connection pool for all participants. Coordinate the vulnerable read phase with queues or barriers rather than hoping a sleep causes overlap; use bounded waits and join threads so failures cannot hang the suite. Use `Thread#value` or equivalent to propagate thread exceptions.

Wrap application code in each manually created thread with `Rails.application.executor.wrap`, and check out that worker's connection inside the wrapper. Use the Executor, not the Reloader, in child threads. It manages Rails execution state, query-cache lifetime, and connection cleanup. If an executor-wrapped parent waits for workers in development, follow the installed Rails threading guide's interlock guidance to avoid blocking autoloading.

Do not share an Active Record instance or connection between participants. Reload results through a fresh query after the writers finish. Retain a deterministic regression if the test framework can support it; otherwise preserve the reproduction command and state the nondeterminism.

## Duplicate creation

`validates :key, uniqueness: ...` performs a query and is not a database uniqueness constraint. Current Rails delegates a missed `find_or_create_by!` lookup to `create_or_find_by!`, including database conflict recovery. The lookup and insert still allow interleaving; do not report the method name alone as a defect. Verify the installed implementation, unique index, and actual conflict handling together.

`create_or_find_by!` relies on a matching database uniqueness constraint and uses a savepoint to handle an insert conflict. It still has an insert/delete/select race. If only some supplied attributes are constrained, its fallback lookup can fail because it searches using all supplied attributes. A uniqueness validator may stop the insert before the database conflict path is reached.

For each candidate method, decide whether callers require validations, callbacks, a persisted model, or a particular conflict result. Bulk `insert_all` and `upsert_all` bypass model instantiation, validations, and callbacks. Their supported options and conflict targets depend on the adapter and Rails version. They are not interchangeable replacements for model creation.

A nullable unique key can permit multiple NULLs. Partial indexes, case folding, tenant columns, and soft-deletion conditions must express the intended invariant. Inspect real indexes and adapter behavior before proposing syntax.

## Lost updates

A Ruby read-modify-save sequence can overwrite another writer's changes. An atomic database increment may solve a counter race but bypasses ordinary model callbacks and validations. Verify its scope, affected-row count, and timestamp behavior.

Optimistic locking uses a locking column, normally `lock_version`, and raises `ActiveRecord::StaleObjectError` on a conflicting write. Decide how callers should resolve a conflict; blindly retrying the same stale value defeats the intent. Retry a complete safe operation only when its semantics permit it.

Pessimistic locking serializes existing rows inside a transaction. `with_lock` reloads and locks a persisted row; it does not lock a row that has not been created. For multi-row invariants, lock a stable parent or acquire locks in a consistent order. Keep lock-holding work short and avoid network calls while locks are held. Verify deadlock and timeout handling rather than introducing unlimited retries.

## Constraint rollout

For an authorized unique-index change, inspect existing duplicates before writing the migration. Surface a business decision about which records to retain. Follow the repository's migration conventions and adapter-specific deployment requirements. Building an index concurrently on PostgreSQL requires a migration outside a DDL transaction; confirm current Rails support and failure cleanup before using it. Creating the file and applying it to production are separate actions.
