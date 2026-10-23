# Transaction semantics and corrections

## Connection and object state

Active Record transactions belong to a database connection, not an individual model. Writes on another connection or external system do not automatically participate. Database rollback also does not restore Ruby instance variables or every loaded model's state. Reload when asserting persisted results.

Keep network calls and slow computation out of a lock-holding transaction when the operation permits it. If partial results are intentional, retain that contract instead of wrapping the whole workflow in a new transaction. Cross-system consistency may need reconciliation or a durable outbox, but an audit should establish the requirement before recommending either.

## Exceptions and nesting

On PostgreSQL, a statement error can abort the transaction. Rescuing `ActiveRecord::StatementInvalid` inside the affected transaction and continuing to issue SQL is unsafe. Rescue outside the failed boundary; restart the complete operation only if its database and external effects make retry safe.

`ActiveRecord::Rollback` is swallowed by the transaction method. Nested transactions ordinarily join their parent, so an inner rollback can be swallowed while the outer transaction commits. `requires_new: true` typically creates a savepoint; releasing it is not a durable outer commit. Do not replace all nested transactions with savepoints without checking intended behavior.

For conflicts such as deadlocks, define a bounded retry at an appropriate complete-operation boundary. Do not retry a partial transaction body after irreversible work. Transaction behavior for non-local exits has changed across Rails versions; reproduce it on the installed version rather than relying on historical `return`, `break`, or `throw` rules.

## Commit callbacks

Rails 7.2 introduced public transaction callback APIs. For a compatible version, a specific transaction can register its effect:

```ruby
Order.transaction do |transaction|
  order.update!(status: "paid")
  transaction.after_commit { ReceiptJob.perform_later(order.id) }
end
```

This is a timing example, not a complete payment or delivery design. `transaction.after_commit`, `Model.current_transaction.after_commit`, and `ActiveRecord.after_all_transactions_commit` have different scopes. Read the installed API contract and choose the scope that matches the outer transaction requirement. Callbacks can execute immediately when no relevant transaction is open.

An exception after commit cannot roll back committed data and can prevent later callbacks from executing. Registering an external operation after commit avoids performing it for rolled-back data, but a crash or enqueue error between commit and delivery remains possible. Report that window explicitly when delivery matters.

For older Rails, use an existing compatible callback mechanism or a model callback when it matches the domain. Do not copy the article's private transaction-record wrapper. Adding a compatibility gem requires checking its current upstream instructions and the application's dependency policy.

## Test the actual boundary

Ensure tests can trigger a real commit. Test transaction wrappers, adapter simulations, and inline job adapters may conceal production timing. Use an isolated database and the project's supported method for disabling the wrapper only in the affected test, with reliable cleanup.

Verify that an outer rollback suppresses deferred work, inner savepoint rollback does not leak its work, the successful operation schedules the intended effect, and an after-commit failure leaves committed state visible. For any retry, test duplicate attempts and partial side effects rather than merely checking the final happy path.
