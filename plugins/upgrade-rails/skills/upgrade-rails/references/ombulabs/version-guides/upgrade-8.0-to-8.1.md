# Rails 8.0 to 8.1

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-8-0-to-rails-8-1) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## Routes drawn with multiple paths (removed)

**Pattern:** `ROUTES_MULTIPLE_PATHS_REMOVED`

[Official source](https://github.com/rails/rails/blob/v8.1.0/actionpack/CHANGELOG.md#L107).

## Configured Sidekiq adapter

**Pattern:** `SIDEKIQ_ADAPTER`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activejob/CHANGELOG.md#L19).

## SuckerPunch adapter

**Pattern:** `SUCKER_PUNCH`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activejob/CHANGELOG.md#L25).

## Benchmark.ms (removed)

**Pattern:** `BENCHMARK_MS_REMOVED`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activesupport/CHANGELOG.md#L7), [Official source](https://github.com/rails/rails/blob/v8.0.0/activesupport/lib/active_support/benchmark.rb#L11).

## ActiveSupport::Configurable

**Pattern:** `AS_CONFIGURABLE`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activesupport/CHANGELOG.md#L407).

## MySQL unsigned_float / unsigned_decimal short-hand

**Pattern:** `MYSQL_UNSIGNED`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activerecord/CHANGELOG.md#L128).

## ignore_leading_brackets config

**Pattern:** `IGNORE_LEADING_BRACKETS_CONFIG`

[Official source](https://github.com/rails/rails/blob/v8.1.0/actionpack/CHANGELOG.md#L147).

## to_time_preserves_timezone config

**Pattern:** `TO_TIME_PRESERVES_TIMEZONE_CONFIG`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activesupport/CHANGELOG.md#L20).

## String#mb_chars / Multibyte::Chars

**Pattern:** `MB_CHARS`

[Official source](https://github.com/rails/rails/blob/v8.1.0/activesupport/CHANGELOG.md#L400).
