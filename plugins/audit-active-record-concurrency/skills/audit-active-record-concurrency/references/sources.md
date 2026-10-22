# Sources and compatibility

These are original instructions derived from published techniques. Rails Kit's MIT license covers these instructions; the linked articles and documentation retain their own rights. Sources checked on 2026-10-23 are listed below. They do not establish the version installed in a target application.

- [One row, many threads: How to avoid database duplicates in Rails applications](https://evilmartians.com/chronicles/one-row-many-threads-how-to-avoid-database-duplicates-in-rails-applications), Dmitry Tsepelev, Evil Martians, 2021: concurrent creation, unique constraints, locks, and alternative persistence methods. Historical benchmarks are not performance promises.
- [Active Record validations](https://guides.rubyonrails.org/active_record_validations.html#uniqueness): uniqueness validation and database enforcement.
- [Active Record Relation](https://api.rubyonrails.org/classes/ActiveRecord/Relation.html): creation/conflict handling and bulk persistence contracts.
- [Optimistic locking](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html) and [pessimistic locking](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html): locking semantics and error handling.
- [PostgreSQL unique indexes](https://www.postgresql.org/docs/current/indexes-unique.html): NULL treatment and multicolumn uniqueness.

The entrypoint supplies the audit/report boundary; the concurrency reference adapts the article into reproduction and correction decisions. Read documentation matching the installed Rails and database versions before emitting API calls or migrations. No additional gem is required by this skill.
