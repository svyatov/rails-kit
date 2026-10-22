---
name: audit-transactions
description: 'Audit Rails transaction boundaries, exception handling, nested transactions, and external side effects. Use when reviewing rollback behavior, rescued database errors, or work that must wait for commit.'
license: MIT
compatibility: Requires Active Record. Public per-transaction callbacks require Rails 7.2 or newer; inspect the installed version and database connections.
---

# Audit transactions

Trace what commits, what rolls back, and what escapes the database transaction. Report findings first; apply fixes only when authorized. See [sources](references/sources.md) for article attribution and modern API references.

## 1. Map the boundary

Read the selected entrypoint, callers, callbacks, services, and exception handlers. Record the Rails version, adapter, connection roles, and transaction/savepoint nesting. Follow the outer caller: returning from a service does not establish that its transaction has committed.

List database writes separately from HTTP requests, mail, jobs, files, cache writes, and other side effects. Identify the required outcome when each stage fails. Do not assume one transaction spans multiple database connections.

Done when the commit boundary and side effects are mapped for the requested operation.

## 2. Inspect failure paths

Read [transaction semantics](references/boundaries.md). Trace rollback, nested savepoints, rescued exceptions, and failures after commit. Check whether a broad rescue reports failure as success or allows more SQL in an aborted transaction.

Use isolated tests to distinguish an outer rollback from an inner savepoint rollback. Assert persisted state through a fresh query, not only an in-memory object. Record whether the test harness itself holds an outer transaction that changes callback timing.

Done when each claimed failure has a reproduction or a code-supported trace, with the distinction stated explicitly.

## 3. Report and correct within scope

For each finding, give the location, failure sequence, persisted and external effects, proposed correction, and verification command. When the runner is unavailable, give a test procedure and missing prerequisites instead. Keep database uniqueness/locking and job delivery analysis bounded to the transaction issue being reviewed.

Use public APIs compatible with the installed Rails version. Preserve intended partial-success behavior. A longer transaction, wider rescue, or generic retry can change business semantics; justify the boundary before changing it.

Done when the report explains both the correction and the remaining failure window. Deferring an effect until commit orders it correctly but does not guarantee its delivery.

## 4. Verify authorized fixes

Exercise success, outer rollback, nested rollback, database failure, and side-effect failure after commit where applicable. Confirm committed data remains committed if a post-commit callback fails. Run affected callers and inspect error propagation.

Report the exact tested paths and remaining uncertainty. Do not claim distributed atomicity or exactly-once external execution from an Active Record transaction.
