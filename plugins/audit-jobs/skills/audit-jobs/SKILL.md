---
name: audit-jobs
description: 'Audit Rails and Ruby background jobs for unsafe retries, duplicate effects, serialization, enqueue timing, delivery gaps, concurrency, and tenant starvation. Use when reviewing job reliability or queue behavior.'
license: MIT
compatibility: Requires a Ruby job implementation or Rails Active Job application. Detect the installed processor, adapter, edition, storage, and runtime configuration before applying backend-specific guidance.
---

# Audit jobs

Review the complete path from enqueue to execution, failure, and recovery. Report findings first; change jobs, configuration, or infrastructure only when the user's request authorizes fixes. See [sources](references/sources.md) for article attribution and upstream evidence.

## 1. Identify the execution contract

Read the selected jobs, enqueue sites, superclass or included modules, adapter configuration, schedules, processor launch commands, queue subscriptions, and locked versions. Check per-job and per-environment overrides, commercial edition features, and database/Redis connections.

State the intended result, tenant identity, external effects, acceptable delay, and failure/recovery expectations. Distinguish Active Job wrapping a processor from the processor's native API. Do not infer deployed behavior solely from a test adapter.

Done when the actual execution stack and job lifecycle are mapped, or unavailable deployment facts are listed.

## 2. Trace correctness and delivery

Read [reliability](references/reliability.md). Inspect argument serialization, record deletion, transaction timing, duplicate execution, partial progress, retry layers, discarded failures, and crash recovery. Follow each external side effect and deduplication key across attempts.

Distinguish durable enqueue, execution timing, duplicate execution, and eventual successful completion. None follows automatically from the others. Use isolated fixtures, local test backends, or approved staging; do not drain, replay, or kill production jobs as an audit step.

Done when failure paths and claimed delivery guarantees are tied to code and the installed backend's documented behavior.

## 3. Inspect concurrency and fairness

Read [queue behavior](references/queues.md) when concurrent execution, scheduling, or latency is in scope. Compare per-tenant queue wait and job runtime under competing workloads. Inspect queue subscriptions, priority, admission limits, long batches, resource pools, and shutdown behavior.

A global queue-age metric does not establish fair service for each tenant. A concurrency limit does not itself establish fair scheduling. Do not propose a new scheduler merely because one is described in an article.

Done when observed contention has a workload explanation, or missing latency/throughput evidence is clearly identified.

## 4. Report and verify

Give each finding a job/enqueue/configuration location, trigger, consequence, evidence, proposed correction, and verification procedure. Separate observed failures, code-supported risks, and unavailable operational evidence. Provide exact commands when the runner exists; otherwise state prerequisites.

For authorized fixes, exercise success, retryable and permanent failure, duplicate execution, failure after partial effects, enqueue during rollback, missing records, and relevant competing workloads. Crash recovery requires a real backend test; inline or fake execution cannot establish it. Report before/after tenant latency where fairness changes.

Keep application invariants intact and changes limited to the demonstrated problem. Report remaining delivery windows and unsupported scenarios instead of promising exactly-once execution.
