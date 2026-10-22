# Factory optimization

Use FactoryProf's total counts, top-level counts, and flamegraph to identify expensive association chains. Inspect the measured factories, their callbacks, model validations, and callers before removing an association.

## Make optional prerequisites explicit

In a temporary local edit, remove one suspected optional association and run the affected scope to discover consumers that rely on it. Treat failures as evidence to inspect, not a target count to reduce. Revert the experiment if the association is necessary for a valid default object.

Move a genuinely optional relationship into a trait. For example, if an estimate can validly exist without a reviewer:

```ruby
factory :estimate do
  trait :with_reviewer do
    association :reviewer, factory: :user
  end
end
```

Update consumers that need it to use `create(:estimate, :with_reviewer)` or pass an explicit reviewer. Check factories that use this factory indirectly, not just direct calls. Keep the default factory valid; do not weaken application validations or database constraints. Run existing factory lint checks if provided.

## Reuse a compatible parent

Prefer an explicit association when a test has a small, readable data graph. For repeated associations throughout a group, TestProf's FactoryDefault can reuse a user, account, or other parent. Load it after `let_it_be` or `before_all` when combining their scopes:

```ruby
require "test_prof/recipes/rspec/let_it_be"
require "test_prof/recipes/rspec/factory_default"
```

```ruby
let_it_be(:account) do
  create_default(:account, preserve_traits: true, preserve_attributes: true)
end
```

This requires FactoryBot's syntax methods in the example group. Defaults created by `create_default` apply to matching factory associations, not every arbitrary `create` call. The RSpec recipe resets ordinary defaults after each example; defaults created inside `before_all` or `let_it_be` survive for that group's lifetime. Plain `before(:all)` is not supported for this integration.

The preservation options prevent reuse when an association asks for incompatible traits or attributes. Check support in the installed TestProf version. Keep distinct records in authorization, tenancy, ownership, and uniqueness tests; a common parent can silently make such tests meaningless. Inspect association overrides and custom factory callbacks that may bypass or defeat the default.

Reprofile the candidate file, then all consumers. Confirm that factory counts fell, required records are still distinct, and full-suite behavior and uninstrumented runtime remain correct.
