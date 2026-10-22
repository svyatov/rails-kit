# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. These instructions are MIT licensed; linked articles and documentation retain their own rights. Recheck installed versions before applying API examples.

- [Squash N+1 queries early with n_plus_one_control test matchers for Ruby and Rails](https://evilmartians.com/chronicles/squash-n-plus-one-queries-early-with-n-plus-one-control-test-matchers-for-ruby-and-rails), Vladimir Dementyev, Evil Martians, 2020: compare query growth rather than depending solely on association heuristics.
- [Fighting the Hydra of N+1 queries](https://evilmartians.com/chronicles/fighting-the-hydra-of-n-plus-one-queries), Evil Martians, 2017: SQL instrumentation and early regression detection. Tool examples are historical.
- [Rails query guide: eager loading](https://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations): loading strategies and strict loading.
- [n_plus_one_control upstream](https://github.com/palkan/n_plus_one_control): authentic gem identity, test-group installation, RSpec and Minitest integrations, population hooks, scale factors, query filtering, and cache settings. The checked source reports version 0.8.0 and Ruby >= 3.1; this is a source baseline, not a requirement or a claim about the latest published release.

The workflow extends the article with explicit authorization, result-correctness, pagination, and bounded-batch checks. Its default requires no new dependency.
