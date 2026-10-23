# Rails 5.0 to 5.1

Read the [official upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-5-0-to-rails-5-1) and the target's release notes before applying changes. The selected rules below are search candidates, not exhaustive compatibility coverage.

## render :text removed

**Pattern:** `RENDER_TEXT`

[Official source](https://github.com/rails/rails/blob/v8.1.0/guides/source/upgrading_ruby_on_rails.md#L1475).

## render :nothing removed

**Pattern:** `RENDER_NOTHING`

[Official source](https://github.com/rails/rails/blob/v8.1.0/guides/source/upgrading_ruby_on_rails.md#L1478).

## redirect_to :back removed

**Pattern:** `REDIRECT_TO_BACK`

[Official source](https://github.com/rails/rails/blob/v8.1.0/guides/source/upgrading_ruby_on_rails.md#L1482).

## *_filter callback methods removed

**Pattern:** `FILTER_METHODS`

[Official source](https://github.com/rails/rails/blob/v5.1.0/actionpack/CHANGELOG.md#L319).

## use_transactional_fixtures removed

**Pattern:** `USE_TRANSACTIONAL_FIXTURES`

[Official source](https://github.com/rails/rails/blob/v5.1.0/activerecord/CHANGELOG.md#L304).
