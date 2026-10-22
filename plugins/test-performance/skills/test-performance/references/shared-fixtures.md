# Shared fixtures and isolation

Choose the narrowest useful lifetime: an example, an example group, or the suite. Shared setup trades repeated creation for stronger isolation requirements.

## Group-local data with `let_it_be`

After Rails and Active Record load, require:

```ruby
require "test_prof/recipes/rspec/let_it_be"
```

Convert one profiled file at a time. Share stable prerequisites, not the action under test. Unlike lazy `let`, `let_it_be` creates its value before the group's examples; this can add unnecessary records or change counts. Inspect nested overrides because both parent and child records can be created.

```ruby
let_it_be(:account, refind: true) { create(:account) }
let(:invoice) { create(:invoice, account: account) }
```

`refind: true` returns a freshly fetched Active Record instance for each example's access. `reload: true` reloads the existing instance. Choose based on mutations and cached associations; neither replaces database rollback. For intentionally immutable objects, `freeze: true` can expose accidental mutation. Keep non-database mutable state example-local or reset it explicitly.

`let_it_be` and `before_all` roll back at the group boundary. Preserve per-example transactions, for example RSpec Rails' `config.use_transactional_fixtures = true`, or the application's equivalent isolation. Check other database connections, jobs, and system-test processes before assuming they share or can see this transaction.

## Replace leaking group setup

Inspect plain `before(:all)` and `before(:context)` hooks that write to the database. For group-local records, use TestProf's transactional `before_all`, required after Active Record loads:

```ruby
require "test_prof/recipes/rspec/before_all"
```

Retain per-example rollback and handle Ruby object mutation as above. Check that all relevant database connection classes load before these transactions begin. A suite-wide fixture deliberately created outside group transactions has a different lifecycle and needs explicit cleanup.

## Suite-level data with AnyFixture

Consider AnyFixture only for expensive, stable reference data reused across many groups, such as a default actor. First confirm that the suite's cleaning strategy will preserve it until final cleanup. The RSpec recipe supplies suite cleanup; it tracks affected tables, so cleanup can delete more than just the registered record. Use an isolated test database.

An explicit API avoids dependency on DSL/refinement differences between TestProf versions:

```ruby
require "test_prof/recipes/rspec/any_fixture"

RSpec.configure do |config|
  config.before(:suite) do
    TestProf::AnyFixture.register(:default_actor) do
      FactoryBot.create(:user)
    end
  end
end

RSpec.shared_context "default actor" do
  let(:default_actor) do
    User.find(TestProf::AnyFixture.cached(:default_actor).id)
  end
end
```

Include the context where needed. Replace redundant creation with access to the fixture, but keep setup of current-user or current-tenant state example-scoped and reset it afterward. Fetch a fresh model instance rather than mutating the cached object. Never register suite data inside an example's rollback transaction.

Keep empty-database tests explicit. The RSpec recipe provides `:with_clean_fixture` for compatible groups; confirm its behavior with the installed version and cleaning strategy before use. Run a second suite invocation and the affected groups in different orders to detect leftovers, missing fixture rows, and accidental reliance on prior tests. For parallel runs, verify creation and cleanup per worker database.

## Existing database pollution

Fix leaking setup before treating cleanup as an optimization. The article's optional `CLEAN_DB` hook calls `ActiveRecord::Tasks::DatabaseTasks.truncate_all`; this is destructive recovery, not routine isolation. Do not run it automatically. Confirm the resolved test databases and obtain explicit authorization before any truncation. If retained as a local recovery tool, guard it to the test environment and run it before suite fixtures are registered.
