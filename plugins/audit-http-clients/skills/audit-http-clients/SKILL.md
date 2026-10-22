---
name: audit-http-clients
description: 'Audit outbound Ruby HTTP integrations for timeouts, unsafe retries, error handling, secret leakage, and failure isolation. Use when reviewing or diagnosing Rails or Ruby service clients.'
license: MIT
compatibility: Requires a Ruby application. Inspect its installed transport, middleware, and job retry layers; no particular HTTP client or circuit breaker is required.
---

# Audit HTTP clients

Audit the Ruby boundary around an external service. Report findings first and change code only when authorized. Keep the scope on Ruby integrations, not browser clients or a general infrastructure redesign. See [sources](references/sources.md).

## 1. Trace the integration

Read the requested client, callers, transport adapter, middleware order, configuration, tests, and locked versions. Identify endpoint operations, authentication, payloads, streaming, error mapping, and retries in callers or jobs.

Record the operation's latency budget and side-effect semantics. Discover the provider's documented idempotency contract when retry decisions depend on it. Do not infer safety solely from an HTTP verb or the presence of an idempotency header.

Done when the request path and retry owners are mapped, or missing provider facts are recorded.

## 2. Inspect failure behavior

Read [timeouts, retries, and isolation](references/reliability.md). Check connection and read/write timeouts, total elapsed time, retry multiplication, error classification, connection reuse, and bounded resource use. A timeout during a write or response does not establish whether the provider completed the operation.

Inspect URL, header, body, and exception logging for credentials or personal data. Review redaction with sentinel secrets instead of real credentials. Use local stubs or an existing approved sandbox for failure experiments; do not induce outages or replay side-effecting calls against production.

Done when each suspected failure is tied to code, configuration, provider documentation, or an isolated reproduction.

## 3. Report the smallest correction

For each finding, give the code location, trigger, consequence, evidence, correction, and test. Distinguish measured failures from untested risks. Use a verification procedure with explicit prerequisites when no executable test command is available.

Preserve the existing client library unless it cannot meet the requirement. A circuit breaker is conditional on a demonstrated isolation need; it does not replace timeouts or make retries safe. Keep fallback behavior explicit so a failed dependency is not silently treated as a successful write.

Done when the proposed behavior states the maximum attempts, failure outcome, logging policy, and recovery behavior relevant to the finding.

## 4. Verify authorized fixes

Exercise applicable cases: slow connection, stalled response, HTTP failure, malformed response, ambiguous write completion, retry exhaustion, and circuit recovery. Verify successful behavior as well as failure propagation.

Assert outbound attempt counts and captured logs with sentinel secrets. For streaming, test a slow multi-chunk response and bounded memory. Report what was simulated, what was measured, and what remains dependent on the provider contract.
