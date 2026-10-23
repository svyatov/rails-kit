# Queue behavior and tenant fairness

## Measure the workload

Record enqueue rate, queue wait, job duration, error/retry rate, backlog, active tenants, and resource limits. Compare a small tenant's latency while a large tenant submits work, not only overall throughput or the oldest queued job.

Identify whether the bottleneck is worker capacity, database connections, external rate limits, CPU, or a small set of long jobs. Increasing thread count can move contention into a downstream service. Compare pool sizes with actual process/thread counts and account for retry traffic.

For scheduled work, verify the intended schedule, time zone, enqueue source, and whether slow execution can overlap the next run. Multiple scheduler processes can have backend-specific deduplication; inspect the deployed setup before reporting duplicate scheduling as fact.

## Interpret queue controls correctly

Strict priority can indefinitely delay lower queues under continuous higher-priority traffic. Weighted selection supplies opportunities, not guaranteed equal runtime when jobs have different costs. Confirm every queue has a subscriber and that launch-time options match checked-in configuration.

Concurrency limits constrain simultaneous execution. They do not necessarily reorder a large backlog fairly, and expired locks can permit overlap. Verify key scope, expiry, process failures, and what happens to blocked or discarded jobs. Include tenant identity only when it matches the intended sharing boundary.

Large numbers of dynamic per-tenant queues have processor-specific discovery and polling costs. Do not assume native Sidekiq, Sidekiq Pro, Solid Queue, and other Ruby processors expose interchangeable queue controls.

## Choose the smallest supported correction

Prefer the existing backend's supported queue, admission, concurrency, or batch controls when measurements justify them. Compare the workload with these options:

- Queue sharding can isolate some contention but does not ensure fairness among tenants sharing a shard.
- Resumable, time-bounded batches can release capacity between chunks. Iteration without yielding does not create fairness by itself.
- Tenant throttling can reduce monopolization, but work routed to a slower queue may remain there after a burst ends.
- A separate per-tenant scheduler adds storage, failure, and recovery responsibilities. Treat it as an architectural proposal requiring evidence, not the default fix.

Verify graceful shutdown and checkpoint behavior for long-running jobs. Test competing workloads before and after a fairness change using the same tenant mix, capacity, and input sizes. Report latency distribution and throughput together; improving one does not establish the other improved.
