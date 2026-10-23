# Rails 6.1 to 7.0

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-1-to-rails-7-0) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## Autoloader configuration removed

**Pattern:** `CLASSIC_AUTOLOADER`

[Official source](https://github.com/rails/rails/blob/v8.1.0/guides/source/upgrading_ruby_on_rails.md#L514).

## to_s(:format) deprecation

**Pattern:** `TO_S_FORMAT`

[Official source](https://github.com/rails/rails/blob/v7.0.0/activesupport/CHANGELOG.md#L24).

## config.action_controller.urlsafe_csrf_tokens set explicitly

**Pattern:** `URLSAFE_CSRF_TOKENS`

[Official source](https://github.com/rails/rails/blob/v7.0.0/actionpack/CHANGELOG.md#L3).
