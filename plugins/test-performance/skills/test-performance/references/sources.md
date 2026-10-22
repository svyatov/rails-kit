# Sources and coverage

Checked 2026-10-23. These are original instructions derived from published techniques, not a copied upstream skill. The repository's MIT license covers this implementation; linked articles and documentation retain their own rights.

## Article

[Railing against time: tools and techniques that got us 5X faster tests](https://evilmartians.com/chronicles/railing-against-time-tools-and-techniques-that-got-us-5x-faster-results), Vitalii Yulieff and Travis Turner, Evil Martians, August 14, 2024. [Read the Markdown version](https://evilmartians.com/chronicles/railing-against-time-tools-and-techniques-that-got-us-5x-faster-results.md). The reported Rails case study reduced runtime from 53 to 33 to 21 to 11 minutes over three optimization stages. These are historical project measurements, not benchmarks for this skill.

| Article technique | Where to apply it |
| --- | --- |
| Prioritize aggregate impact, limit effort, measure before/after | Main workflow |
| StackProf, Speedscope Sandwich view, sampled runs | Profiling guide |
| FactoryProf statistics and factory flamegraphs | Profiling and factory guides |
| Feature-specific testing controls and RSpec metadata | Optional side effects guide |
| Optional associations moved into explicit traits | Factory guide |
| Default user reused through AnyFixture | Shared fixtures guide |
| Replace leaking `before(:all)`; optional database recovery | Shared fixtures guide |
| RSpecDissect selects expensive setup; `let_it_be` reuses it | Profiling and shared fixtures guides |
| `create_default` reuses associated records | Factory guide |

Logging and API calls are investigation candidates mentioned by the article, not separately demonstrated optimizations. The side-effects guide treats them accordingly. Exception-safe mode restoration, production-default behavior, compatible factory defaults, and isolation verification are adaptations for safe reuse.

## Upstream API checks

TestProf documentation and implementation were checked at [3de23ecc95fa50c10343c80523c17ae4107fe3a4](https://github.com/test-prof/test-prof/tree/3de23ecc95fa50c10343c80523c17ae4107fe3a4), whose version file reports 1.6.4. This is a source baseline, not a required version or claim about the latest published gem. Recheck the installed release before applying recipes and the current release before changing dependencies.

- [Installation](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/getting_started.md), [Ruby profilers](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/profilers/ruby_profilers.md), and [sampling](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/recipes/tests_sampling.md): dependencies, report formats, and explicit sampling setup.
- [FactoryProf](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/profilers/factory_prof.md) and [RSpecDissect](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/profilers/rspec_dissect.md): counters, flamegraphs, and setup attribution.
- [FactoryDefault](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/recipes/factory_default.md): load order, group lifetime, trait and attribute preservation.
- [BeforeAll](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/recipes/before_all.md) and [LetItBe](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/recipes/let_it_be.md): transaction boundaries, model-state leakage, and modifiers.
- [AnyFixture](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/docs/recipes/any_fixture.md), [implementation](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/lib/test_prof/any_fixture.rb), and [RSpec recipe](https://github.com/test-prof/test-prof/blob/3de23ecc95fa50c10343c80523c17ae4107fe3a4/lib/test_prof/recipes/rspec/any_fixture.rb): registration, cached instances, table cleanup, and clean-fixture contexts.
- [StackProf upstream](https://github.com/tmm1/stackprof): profiler installation and sampling modes. [Speedscope](https://www.speedscope.app/): local profile inspection.
