# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. These instructions are MIT licensed; linked sources retain their own rights. Examples from articles are not universal settings or production-ready clients.

- [The IDEAL HTTP client](https://evilmartians.com/chronicles/its-dangerous-to-go-alone-take-our-guide-to-the-ideal-http-client.md), Artur Petrov and Travis Turner, Evil Martians, 2023: timeout, retry, error, observability, and client-boundary workflow.
- [Circuit breakers and Ruby in 2025](https://evilmartians.com/chronicles/circuit-breakers-and-ruby-in-2025-dont-break-your-launch.md), George Asfour and Travis Turner, Evil Martians, 2025: failure isolation and breaker configuration. Its simplified breaker implementations are explanatory examples, not reusable production code.
- [Net::HTTP documentation](https://ruby-doc.org/3.4.1/stdlibs/net/http/Net/HTTP.html) and [upstream implementation](https://github.com/ruby/net-http/blob/master/lib/net/http.rb): socket timeout and internal retry semantics. Use the installed Ruby and gem version before selecting options.
- [Faraday Retry upstream](https://github.com/lostisland/faraday-retry) and [middleware](https://github.com/lostisland/faraday-retry/blob/main/lib/faraday/retry/middleware.rb): method eligibility, predicates, retries, and status handling.
- [Faraday logging formatter](https://github.com/lostisland/faraday/blob/main/lib/faraday/logging/formatter.rb): header/body logging and filters.
- [Stoplight upstream](https://github.com/bolshakov/stoplight) and [v5.8.3 documentation](https://github.com/bolshakov/stoplight/tree/v5.8.3): error classification and circuit state. Both the checked v5.8.3 and current source support tracked/skipped errors; avoid inferring API differences solely from the article date.

Library references support audits of existing installations, not default dependency recommendations. Before proposing an addition or upgrade, open that version's upstream instructions, verify the package identity and compatibility, and use its published installation method.
