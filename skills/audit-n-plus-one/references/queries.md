# Measuring and correcting query growth

## Instrument the executed boundary

Measure request rendering, serializer output, resolver execution, or complete service enumeration. Merely creating an Active Record relation does not execute it. An association can appear preloaded while a later `where`, `order`, `count`, or `exists?` issues another query for each row.

With `sql.active_record` notifications, inspect payloads, query cache flags, and call sites. State filters for schema, transaction, and setup queries. Do not exclude the repeated SQL simply to obtain a constant count. Keep instrumentation scoped to the block and remove subscribers afterward.

Compare at least two collection sizes that exercise different numbers of rows. For pagination, increase the actual page size or choose another boundary that processes the growing collection; adding hidden rows outside a fixed page proves nothing. Ensure authorization permits the measured records.

Keep request caches, application caches, and SQL query caches comparable. A warm-cache result and a cold-cache result answer different questions. A test that counts cached SQL can expose repeated ORM work even when fewer database round trips occur; label what was counted.

## Optional query-growth matcher

If the project already uses `n_plus_one_control`, follow its installed version. For a new dependency, first confirm upstream compatibility and the project's dependency policy. Its upstream Gemfile setup is `gem "n_plus_one_control", group: :test`, followed by `bundle install`. Do not add it merely to perform a source audit.

RSpec integration loads `n_plus_one_control/rspec`. A group marked `:n_plus_one` provides `populate`, and the operation is passed fresh inside the matcher block:

```ruby
describe "GET /posts", :n_plus_one do
  populate { |n| create_list(:post, n, :with_author) }

  it "keeps query count independent of posts rendered" do
    expect { get "/posts" }
      .to perform_constant_number_of_queries.with_scale_factors(2, 5, 10)
  end
end
```

Adapt factories, authentication, and pagination to the real endpoint. Each generated post must have the relationships that expose the suspected query. Assert status and output in a separate correctness example or within the operation as appropriate. Do not use a memoized RSpec subject for the measured request.

Minitest integration loads `n_plus_one_control/minitest` and exposes `assert_perform_constant_number_of_queries` with `populate:` and `scale_factors:`. Read the installed integration before adding it to the test base. Upstream defaults filter SELECT queries and include cached queries; verify local overrides and explain them.

## Choose a correction

- `preload` loads associations separately. `eager_load` joins them. `includes` can change strategy when associated tables are referenced. Inspect generated SQL and returned rows rather than assuming these methods are interchangeable.
- Strict loading catches unexpected lazy association loading. It does not detect every repeated aggregate, custom query, or external call.
- Load grouped counts or aggregates once when callers need a count rather than full records. Verify zero-match behavior and filtering.
- Batch independent lookups, including GraphQL resolver lookups, using the application's established loader. Scope caches to the request and authorization context.
- For large datasets, use bounded batches rather than preloading everything. Record query counts per batch and memory constraints; more batches legitimately mean more queries.

Avoid asserting a fragile exact query count when the meaningful invariant is growth. Retain result assertions: fewer queries that omit records or leak another tenant's records are a regression.
