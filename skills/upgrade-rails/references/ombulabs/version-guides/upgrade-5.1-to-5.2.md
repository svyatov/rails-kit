# Rails 5.1 to 5.2

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-5-1-to-rails-5-2) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## class_name option with unquoted constant

**Pattern:** `CLASS_NAME_CONSTANT`

[Official source](https://github.com/rails/rails/blob/v5.2.0/activerecord/CHANGELOG.md#L399).

## evented_redis Action Cable adapter (removed)

**Pattern:** `EVENTED_REDIS_ADAPTER`

[Official source](https://github.com/rails/rails/blob/v5.2.0/actioncable/CHANGELOG.md#L3).
