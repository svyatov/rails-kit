# HTTP reliability in Ruby

## Timeout budgets

In Net::HTTP, `open_timeout` limits opening a connection; `read_timeout` and `write_timeout` apply to individual socket operations. A response that continually sends small chunks can exceed the read timeout in total elapsed time. Check the installed library's meaning of each timeout, including pool acquisition and streaming.

Set timeouts from the caller's actual budget, with room for retries and cleanup. Do not label illustrative values as universal defaults or wrap arbitrary Ruby client code in asynchronous `Timeout.timeout` as a routine correction.

For Net::HTTP HTTPS connections, retain TLS and certificate verification. Never fix a connection problem by disabling verification.

## Retry ownership and ambiguous outcomes

Inventory transport retries, HTTP middleware retries, application loops, and job retries. Bound both attempts and elapsed time across layers. Net::HTTP has internal retry behavior for selected transport errors and eligible methods; inspect `max_retries` rather than assuming a request happens once. HTTP response status retries are a separate policy.

An idempotent method does not prove a provider behaves correctly, and a non-idempotent operation may be safely retried only under a verified deduplication contract. Check key scope, retention, payload matching, and repeated-response behavior. Reuse the same logical operation key across retries; a new random key per attempt defeats deduplication.

Choose retryable statuses and exceptions deliberately. Apply bounded backoff and jitter where appropriate. Respect provider rate-limit guidance without waiting beyond the caller's deadline. Treat authentication, invalid payloads, and permanent business rejection separately from transient failures.

For Faraday Retry, `retry_if` is combined with the configured eligible methods using OR in the checked implementation. It is not a veto for methods already allowed by `methods`. If every retry requires a predicate, inspect the installed middleware and configure the method list accordingly, for example `methods: []`. Test the actual retry attempt count. Do not silently apply this option to another library.

## Error and circuit behavior

Map transport failures and unsuccessful responses into meaningful application exceptions without losing diagnostic causes. A returned HTTP 503 is not a raised exception unless the client maps it that way. Preserve errors that the caller or job processor must see to retry or report failure.

If a breaker is already present, inspect its identity, tracked/skipped errors, state storage, thresholds, cooldown, and fallback. Use stable dependency or operation identities, avoiding per-request or unbounded per-user breaker names. Group operations only when their failure domains match.

Stoplight's checked API supports `tracked_errors` and `skipped_errors`; skipped errors take precedence. Its broad default can count normal business errors as dependency failures. Verify installed behavior before suggesting configuration. A breaker still needs transport timeouts and does not solve duplicate side effects.

Test healthy execution, classified failures, excluded business errors, rejection while open, and both successful and failed recovery. Exercise state-store failure if the application's guarantee depends on shared breaker state. Do not add Redis or replace an existing breaker simply to match an article.

## Logging and resources

Review request URLs, headers, payloads, response bodies, exception messages, and tracing metadata. Disabling body logging alone does not protect authorization headers or query-string secrets. Faraday's checked logging formatter enables headers by default; inspect custom formatters and middleware configuration.

Test with unique fake tokens and assert they do not occur anywhere in captured output. Preserve useful status, duration, attempt count, and correlation metadata without including credentials.

For downloads or large responses, verify streaming and size limits before materializing the body. Confirm connection-pool limits against job/thread concurrency and that responses and connections are released on failure.
