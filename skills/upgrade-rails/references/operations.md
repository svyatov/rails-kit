# Upgrade operations

## Baseline checks

Find actual `*_spec.rb` or `*_test.rb` files and the application's documented commands. A transitive Minitest dependency is not evidence of a test suite. Record test failures, pending examples, deprecations, and unavailable services separately.

For an application without runnable tests, use its installed bundle and local/test configuration to check boot, routes, database migration status when a database is available, existing asset/build commands, and representative read-only requests. These checks give partial confidence. They do not verify unexercised application behavior. Never create or migrate a database merely to make a readiness check pass. Shut down any test server started for the check.

## Dual boot

Use dual boot when comparing versions while normal development continues is useful. Reuse the application's existing setup. If selecting `next_rails`, read its [upstream documentation](https://github.com/fastruby/next_rails) and check Ruby/Rails compatibility before adding it. An external skill is not required.

Keep current and target lockfiles reproducible. Run the same tests, boot checks, assets, and representative requests with each bundle. CI must run the intended bundle instead of silently reusing the other bundle's cache or environment. A compatibility branch should describe an actual version-dependent behavior and remain covered on both sides. Remove dual-boot support only when requested, after the target deployment has been verified.

## Framework defaults

Use the [official default-transition procedure](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#configure-framework-defaults) and the target version's [configuration guide](https://guides.rubyonrails.org/configuring.html). Inspect the existing `config.load_defaults`, environment overrides, and transition initializers together. Check when each setting is consumed; an initializer can be too late for some boot-time configuration.

Enable one behavior or a closely related group at a time. Record the setting, current effective value, proposed value, affected behavior, regression checks, deployment compatibility, and any reason for deferral. Verify job timing with the actual adapter, serialization with existing stored values, session/cookie compatibility across versions, and cache readability across a rolling deployment. New generated-app choices, such as an asset pipeline or queue backend, are not automatically required migrations.

Once the intended settings are verified, update `config.load_defaults`. Remove a transition initializer only after accounting for every active override it contains. Treat data and serialization changes separately from code rollback.

## Configuration preview

Inspect `app:update` output in a disposable application copy using the exact target bundle and the application's generator configuration. Record the command and environment, then compare the resulting files with the originals. Preserve deployment files, secrets, custom middleware, routes, and environment settings unless a verified compatibility change requires an edit. A generated fresh-app diff is supporting evidence, not an exact prediction of the update task.

The [official update-task documentation](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#the-update-task) explains the interactive diff workflow. In the real checkout, apply only reviewed changes and rerun the application's checks.
