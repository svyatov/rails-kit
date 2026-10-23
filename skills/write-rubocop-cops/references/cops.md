# Implementing and testing a cop

## AST and callbacks

Derive modern cops from `RuboCop::Cop::Base`. Inspect the parsed AST using tools already supplied by the installed stack before writing a matcher from memory. `def_node_matcher` matches a particular node shape; `def_node_search` searches a subtree. Select the one that expresses the rule rather than traversing the entire tree manually.

Use the narrowest relevant callback and `RESTRICT_ON_SEND` for send-based rules when supported. Bare calls, explicit receivers, safe-navigation calls, and constant receivers have different AST forms. An `on_send` callback alone does not handle `csend`; an alias is insufficient if the matcher still accepts only `send` nodes.

For block rules, inspect ordinary blocks, numbered parameters, and implicit `it` blocks if the supported target Ruby/parser versions permit them. Do not impose unsupported syntax in an older project's tests.

## Test the contract

Use existing project spec helpers and RuboCop's supported test helpers. With RSpec, `expect_offense` asserts the message and marked range, `expect_no_offenses` covers accepted source, and `expect_correction` checks the complete rewritten source. Keep a regression for a near-miss that must remain accepted.

Examples must exercise semantic boundaries, not just prove the matcher's implementation repeats its own pattern. For a rule about a particular API receiver, include an unrelated receiver with the same method name. For a rule about argument shape, cover absent, extra, and dynamic arguments where meaningful.

Test config overrides, file inclusion, and runtime/gem gates when they are part of the rule. Run the cop from the project's normal RuboCop command so a correct but unloaded class does not appear finished.

## Correction safety

Extend `RuboCop::Cop::AutoCorrector` when implementing corrections. Edit source ranges through the provided corrector rather than reconstructing a whole file. Preserve comments, parentheses, evaluation order, and side effects.

Test multiple and nested offenses, overlapping edits, multiline expressions, and a second pass. Parseable output alone does not establish equal behavior. Replacing a method because it is usually equivalent can fail with overridden methods or unknown receiver types.

Set `Safe` and `SafeAutoCorrect` according to the actual proof and the project's supported environments. When the analysis cannot establish receiver behavior, narrow the rule, mark the uncertainty accurately, or omit the correction. Do not run unsafe correction across the repository as an incidental validation step.

## Target versions and packaging

Use target Ruby and gem constraints supported by the installed RuboCop API, such as `minimum_target_ruby_version` or `requires_gem`. Lockfile-based gates need the relevant gem information. Do not use the linter process's `RUBY_VERSION` or loaded application constants as a substitute for target metadata.

Honor explicit `AllCops` target settings, including `TargetRubyVersion` and `TargetRailsVersion` for Rails-specific rules, before inferred lockfile versions. Check the installed API for honoring those settings. A rule that forbids a supported Rails idiom requires an explicit project policy; it is not a framework best-practice check by default.

For a repository-local rule, `.rubocop.yml` can still load custom files through `require`. Preserve that structure if it already works. For a distributable extension, use the plugin API and its supported packaging when the intended RuboCop range permits it. The plugin system was introduced in RuboCop 1.72; it does not make local `require` loading obsolete.

Prefer the current public configuration mechanism over historical `Inject.defaults!` examples. Add dependencies only when justified, after checking upstream identity, supported versions, and published installation instructions. A single local rule does not inherently require a new gem or generator.
