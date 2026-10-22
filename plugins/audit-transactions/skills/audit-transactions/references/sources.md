# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. The instructions are MIT licensed; linked articles and documentation retain their own rights.

- [The silence of the Ruby exceptions: a Rails/PostgreSQL database transaction thriller](https://evilmartians.com/chronicles/the-silence-of-the-ruby-exceptions-a-rails-postgresql-database-transaction-thriller.md), Andrey Novikov, Evil Martians, 2018: aborted transactions, swallowed errors, and long-running imports.
- [Rails' after_commit everywhere](https://evilmartians.com/chronicles/rails-after_commit-everywhere.md), Vladimir Dementyev, Evil Martians, 2018: external side effects and outer commit timing. Its private transaction integration is historical, not a recommended implementation.
- [Active Record transactions](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html): connection scope, exception handling, savepoints, object state, and callbacks.
- [Rails 7.2 release notes](https://guides.rubyonrails.org/7_2_release_notes.html#per-transaction-commit-and-rollback-callbacks) and [public transaction API](https://api.rubyonrails.org/classes/ActiveRecord/Transaction.html): public callback availability and lifecycle.
- [Active Record callbacks](https://guides.rubyonrails.org/active_record_callbacks.html): callback execution, avoiding recursive saves, and failures after commit.

The workflow adapts the articles into an audit with explicit failure evidence, version checks, and delivery limits. Current unversioned documentation is a reference baseline; use the installed version before selecting an API. No extra dependency is required.
