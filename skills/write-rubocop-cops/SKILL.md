---
name: write-rubocop-cops
description: "Write and test custom RuboCop cops for Ruby and Rails conventions, with version-aware rules and safe autocorrection."
license: MIT
disable-model-invocation: true
compatibility: Requires a Ruby project using RuboCop. Use its locked RuboCop, parser, extension packaging, and test framework.
---

# Write RuboCop cops

Turn an explicit Ruby or Rails convention into a narrow, tested static-analysis rule. Follow the project's RuboCop organization and supported versions. See [sources](references/sources.md) for article attribution and current APIs.

## 1. Define the rule

Read the convention, relevant code, existing cops/configuration, Gemfile.lock, and tests. Check whether an existing built-in or installed extension cop, including RuboCop Rails, already covers it before creating another.

Validate a Rails/Ruby rule against official guidance for the target versions before enforcing it. Preserve supported framework idioms; label a stricter project preference as a project preference. If a requested rule conflicts with framework behavior or would weaken correctness, explain the conflict and resolve the rule's intent before implementing it.

State which source forms are offenses and which are allowed. Separate a syntactic rule from assumptions about receiver types or runtime behavior. Resolve a missing policy decision before enforcing it across a codebase.

Done when representative rejected and accepted examples define the rule, including relevant false-positive cases.

## 2. Write failing cop tests

Read [implementation and testing](references/cops.md). Follow existing test helpers. Test exact offense locations/messages and accepted syntax. Include safe navigation, receiver variants, blocks, arguments, or multiline forms only where relevant to the rule.

For a version-dependent rule, test supported, unsupported, and missing target metadata. Establish that the test fails because the rule is absent or incorrect, not because the test harness cannot load.

Done when the focused tests expose the requested gap.

## 3. Implement the smallest matcher

Use the installed RuboCop public API, a narrow callback, and an AST matcher that expresses the rule. Handle safe-navigation node shapes explicitly when applicable. Preserve the distinction between the Ruby code being analyzed and the runtime running RuboCop.

Add autocorrection only when requested or clearly part of the convention and when its safety can be demonstrated. A diagnostic-only cop is valid. Integrate one local cop through the existing configuration; create a distributable extension only when requested.

Done when focused tests pass and the cop loads through the same command the project uses.

## 4. Verify safety and integration

Run accepted/rejected cases, correction tests if applicable, and the project's relevant checks. Run the cop against representative real source and inspect the offenses for false positives. Exercise a second correction pass to detect unstable output.

Report the cop name, configured scope, how to run it, and correction limits. Avoid unrelated repository-wide corrections or enabling rules outside the requested scope.
