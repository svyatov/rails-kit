# Rails 7.0 to 7.1

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-7-0-to-rails-7-1) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## legacy_connection_handling removed

**Pattern:** `LEGACY_CONNECTION_HANDLING`

[Official source](https://github.com/rails/rails/blob/v7.1.0/activerecord/CHANGELOG.md#L2018).

## preview_path singular deprecated

**Pattern:** `PREVIEW_PATH`

[Official source](https://github.com/rails/rails/blob/v7.1.0/actionmailer/CHANGELOG.md#L137).

## ActiveRecord::Migration.check_pending! deprecated

**Pattern:** `MIGRATION_CHECK_PENDING`

[Official source](https://github.com/rails/rails/blob/v7.1.0/activerecord/CHANGELOG.md#L526).

## Rails.application.secrets and encrypted secrets deprecated

**Pattern:** `SECRETS_YML_ENC`

[Official source](https://github.com/rails/rails/blob/v7.1.0/railties/CHANGELOG.md#L165).
