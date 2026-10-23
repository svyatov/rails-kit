# Rails 7.2 to 8.0

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-7-2-to-rails-8-0) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## enum with keyword-arguments form

**Pattern:** `ENUM_KWARGS`

[Official source](https://github.com/rails/rails/blob/v8.0.0/activerecord/CHANGELOG.md#L64).

## read_encrypted_secrets config

**Pattern:** `READ_ENCRYPTED_SECRETS`

[Official source](https://github.com/rails/rails/blob/v8.0.0/railties/CHANGELOG.md#L31).

## unsigned_float / unsigned_decimal in migrations

**Pattern:** `UNSIGNED_FLOAT_DECIMAL`

[Official source](https://github.com/rails/rails/blob/v8.0.0/activerecord/CHANGELOG.md#L141).

## ENV["SCHEMA_CACHE"] usage

**Pattern:** `ENV_SCHEMA_CACHE`

[Official source](https://github.com/rails/rails/blob/v8.0.0/activerecord/CHANGELOG.md#L44).

## Benchmark.ms

**Pattern:** `BENCHMARK_MS`

[Official source](https://github.com/rails/rails/blob/v8.0.0/activesupport/CHANGELOG.md#L59), [Official source](https://github.com/rails/rails/blob/v8.0.0/activesupport/lib/active_support/benchmark.rb#L11).

## Routes drawn with multiple paths

**Pattern:** `ROUTES_MULTIPLE_PATHS`

[Official source](https://github.com/rails/rails/blob/v8.0.0/actionpack/CHANGELOG.md#L131).
