# Profiling

## Dependencies and setup

Reuse installed versions and the repository's test launcher. Before adding a gem, open its upstream README and gemspec, check the current release and compatibility with the locked Ruby and test framework, and follow its installation instructions. Keep profiling dependencies out of production groups. Do not install every profiler.

The [TestProf installation guide](https://github.com/test-prof/test-prof/blob/master/docs/getting_started.md) adds `gem "test-prof", "~> 1.0"` to the test group, followed by `bundle install`. Check the current guidance before choosing a constraint. TestProf's [Ruby profiler guide](https://github.com/test-prof/test-prof/blob/master/docs/profilers/ruby_profilers.md) uses `gem "stackprof", ">= 0.2.9", require: false` in the development/test group for StackProf. Review lockfile changes for unrelated upgrades.

The commands below assume a working `bundle exec rspec` launcher. Substitute the application's launcher and scope. Confirm that a report was produced; a passing test command alone does not establish that instrumentation loaded.

## Call stacks first

```sh
TEST_STACK_PROF=1 bundle exec rspec
```

Inspect the reported StackProf JSON locally in [Speedscope](https://www.speedscope.app/), including its Sandwich view. Find wide stacks and follow them back to their callers: persistence, callback chains, factory creation, log formatting, and service calls. Distinguish time inside a method from time in its descendants. Treat a hot method as evidence to investigate, not permission to bypass its behavior.

For large suites, explicitly load the sampling recipe before using `SAMPLE`:

```ruby
require "test_prof/recipes/rspec/sample"
```

```sh
TEST_STACK_PROF=1 SAMPLE=1000 bundle exec rspec
```

Record the sample and seed. Reprofile a fixed relevant scope for comparison because separately drawn samples can differ. If boot dominates, use `TEST_STACK_PROF=boot` with one representative spec and report boot separately.

## Factory cost and cascades

```sh
FPROF=1 bundle exec rspec
FPROF=flamegraph bundle exec rspec
```

FactoryProf counts persisted factory creation. Compare total and top-level counts: many nested creations can reveal association cascades. Read the flamegraph alongside factory definitions to identify the repeating chains. Nested times overlap; summing rows does not give a valid total. FactoryProf does not account for all non-persisted object construction.

For a candidate file, save its counts and total factory time before editing. Repeat the identical profile afterward, as well as the unprofiled runtime.

## Per-example setup

```sh
RD_PROF=1 bundle exec rspec
```

RSpecDissect ranks groups by setup time, including `before(:each)` and `let` evaluation. Select high absolute setup cost, then inspect what can be shared. A high percentage in a tiny file can have little suite-wide value. Use [shared fixtures](shared-fixtures.md) only after identifying repeated, compatible setup.

Keep report paths and enough context to reproduce the finding. Store generated profiles outside source directories; use unique names or TestProf's `TEST_PROF_REPORT` suffix when necessary to preserve before/after artifacts.
