# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. These instructions are MIT licensed; linked publications retain their own rights.

- [Fair by design: orchestrating background jobs in Ruby](https://evilmartians.com/chronicles/fair-by-design-orchestrating-background-jobs-in-ruby.md), Alexander Baygeldin and Travis Turner, Evil Martians, 2026: tenant latency, sharding, resumable work, throttling, and scheduler tradeoffs. The article's scheduler preference is not a default recommendation for all applications.
- [Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html): serialization, GlobalID, retry/discard handling, transaction timing, continuations, and backend distinctions.
- [Rails 8.1.4 enqueue implementation](https://github.com/rails/rails/blob/v8.1.4/activejob/lib/active_job/enqueuing.rb) and [Solid Queue 1.7.0 enqueue errors](https://github.com/rails/solid_queue/blob/v1.7.0/README.md#errors-when-enqueuing): rejected, failed, and deferred enqueue outcomes. These versioned sources establish the reviewed behavior, not a required minimum version.
- [Solid Queue](https://github.com/rails/solid_queue): transaction coupling, concurrency limits, failures, scheduling, and recovery. Confirm configuration and installed version before claiming support.
- [Sidekiq Best Practices](https://github.com/sidekiq/sidekiq/wiki/Best-Practices): native JSON arguments, idempotency, and concurrent execution.
- [Sidekiq Reliability](https://github.com/sidekiq/sidekiq/wiki/Reliability): open-source fetch loss window and commercial recovery behavior.
- [Sidekiq Error Handling](https://github.com/sidekiq/sidekiq/wiki/Error-Handling), [Active Job integration](https://github.com/sidekiq/sidekiq/wiki/Active-Job), and [Advanced Options](https://github.com/sidekiq/sidekiq/wiki/Advanced-Options): retry layers, queue policy, transactional push, and processor configuration.

The general reliability workflow supplements the fairness article with upstream processor contracts. The commit-to-external-enqueue gap is a consequence of separate operations, not a claim that every backend configuration has the same gap. These are current documentation baselines, not proof of the target deployment's settings or guarantees. No new processor, commercial license, or fairness gem is required by this skill.
