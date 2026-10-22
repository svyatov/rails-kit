---
name: audit-active-record-concurrency
description: "Audit concurrent Active Record writes for duplicate records, lost updates, and broken database invariants."
license: MIT
disable-model-invocation: true
compatibility: Requires an Active Record application. Reproduction needs an isolated test database using the relevant database adapter and separate connections.
---

# Audit Active Record concurrency

Identify invariants that fail when writes overlap. Report findings first; modify code only when the user's request authorizes fixes. This is a concurrency audit, not a general model review. For source attribution and API limits, see [sources](references/sources.md).

## 1. Define the write invariant

Read the requested write paths, models, migrations, database indexes, adapter, isolation settings, and locked Rails version. Follow every writer of the affected data, including jobs, imports, callbacks, bulk SQL, and deletion paths.

State the invariant precisely: for example, one membership per account/user pair, or a counter that includes every accepted increment. Include tenant scope, normalization, soft deletion, and nullable keys where relevant. Compare application validation with the database constraint actually present, not merely an old migration.

Done when the invariant, competing writers, and database enforcement are identified.

## 2. Establish the race

Read [race reproduction and fixes](references/concurrency.md). Trace the interleaving between the read and write that could violate the invariant. Reproduce it with separate database connections and coordinated execution in an isolated test database where practical.

Use the production adapter's semantics. SQLite serialization is not evidence that a PostgreSQL race is absent. Threaded tests must propagate exceptions and give each thread its own pooled connection. A surrounding test transaction can hide setup records from those connections.

Done when there is a failing reproduction or a concrete interleaving supported by code and schema. Label an unexecuted race as a risk, not an observed failure.

## 3. Select the smallest correction

Prefer a database constraint for a database invariant. Select atomic creation, an atomic update, optimistic locking, or pessimistic locking according to the operation's semantics. Inspect callbacks, validations, return values, and conflict behavior before replacing one persistence method with another.

Report an index migration separately if existing duplicates or deployment locks require a cleanup and rollout plan. Do not silently delete duplicates or run a production migration. Keep transaction lifecycle and external-delivery analysis in their own scope; this audit covers the race they expose.

Done when each finding has a location, evidence, impact, proposed correction, and verification command. If the runner is unavailable, give the verification procedure and its missing prerequisites instead of inventing a command. Rank confirmed integrity failures above speculative performance concerns.

## 4. Verify authorized fixes

Run the reproduction repeatedly, relevant ordinary write tests, and competing create/update/delete paths. Verify both final database state and each caller's result, including conflict losers. Test NULL and scoped keys when they affect uniqueness.

Report the adapter, connection count, commands, observations, and any untested interleavings. A passing sequential model validation test does not establish concurrency safety.
