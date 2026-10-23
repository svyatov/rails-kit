# Rails 7.1 to 7.2

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-7-1-to-rails-7-2) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## Transaction-aware job enqueuing

**Pattern:** `TRANSACTION_JOBS`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activejob/lib/active_job/enqueue_after_transaction_commit.rb#L13).

## params comparison removed

**Pattern:** `PARAMS_COMPARISON`

[Official source](https://github.com/rails/rails/blob/v7.2.0/actionpack/CHANGELOG.md#L116).

## ActiveRecord.connection deprecated

**Pattern:** `AR_CONNECTION`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/CHANGELOG.md#L331).

## Rails.application.secrets removed

**Pattern:** `SECRETS_REMOVED`

[Official source](https://github.com/rails/rails/blob/v7.2.0/railties/CHANGELOG.md#L61).

## ActiveRecord::Migration.check_pending! removed

**Pattern:** `MIGRATION_CHECK_PENDING_REMOVED`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/CHANGELOG.md#L446).

## Ruby Version Requirement

**Pattern:** `RUBY_VERSION`

[Official source](https://github.com/rails/rails/blob/v7.2.0/rails.gemspec#L12).

## Positional serialize argument removed

**Pattern:** `SERIALIZE_SYNTAX`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/CHANGELOG.md#L421), [Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/lib/active_record/attribute_methods/serialization.rb#L183).

## fixture_path removed

**Pattern:** `FIXTURE_PATH`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/CHANGELOG.md#L429).

## Association query_constraints option

**Pattern:** `QUERY_CONSTRAINTS`

[Official source](https://github.com/rails/rails/blob/v7.2.0/activerecord/CHANGELOG.md#L103).
