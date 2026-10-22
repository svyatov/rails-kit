---
name: audit-n-plus-one
description: 'Audit Rails requests, serializers, and services for N+1 queries by measuring query growth as data grows. Use for repeated SQL, slow collection rendering, or N+1 regression coverage.'
license: MIT
compatibility: Requires Ruby and a runnable application or SQL trace. Regression examples cover Rails with RSpec or Minitest; use the project database and test runner.
---

# Audit N+1 queries

Find repeated queries whose cost grows with the collection being processed. Report findings first; change code only when authorized. This audits application query behavior, not the speed of the test suite. See [sources](references/sources.md).

## 1. Select the operation

Inspect the requested request, serializer, GraphQL resolver, or service and follow the collection through rendering or enumeration. Read its query, associations, pagination, authorization scope, and existing query instrumentation. Identify the actual input size consumed by this path.

Record Rails and adapter versions, command, input shape, result size, and cache state. Prefer existing SQL notifications or test helpers before proposing another gem.

Done when the exact operation and the data dimension expected to increase work are identified.

## 2. Measure growth

Read [measurement and corrections](references/queries.md). Run the complete operation at multiple meaningful sizes with equivalent setup. Count and group SQL by shape and call site. Exclude fixture creation and unrelated setup from the measurement.

Force fresh execution at every size. A lazy relation, memoized subject, cached response, or fixed page size can make a broken path appear constant. Record cached SQL separately or state whether it is included.

Done when query growth is associated with an observed call site, or the report explicitly states that the suspected path did not execute or could not be measured.

## 3. Explain the finding

For each finding, report the location, operation, input sizes, query counts, repeated query shape, effect, and proposed correction. Distinguish demonstrated growth from a source-only concern. Constant-query checks do not prove efficient SQL or correct output.

Choose loading, batching, or an aggregate based on required behavior. Preserve row filtering, authorization, ordering, pagination, and missing-association semantics. Avoid replacing N+1 queries with a join that duplicates records or loading an unbounded graph into memory.

Done when every proposed fix explains both the reduced queries and how result semantics will remain intact.

## 4. Verify authorized fixes

Repeat the same measurements and assert returned values as well as query growth. Keep a regression that fails on the original implementation. For ordinary association loading, a constant count may be appropriate; for batched processing, assert bounded growth per batch instead.

Run affected tests and report before/after counts, cache conditions, and uncovered entrypoints. Do not extrapolate from one endpoint to all application queries.
