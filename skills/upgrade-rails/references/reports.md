# Upgrade reports

Use only the sections needed by the request. Replace placeholders with observed evidence; omit unavailable estimates. Distinguish confirmed failures, search candidates, and unverified behavior.

## Upgrade report

```markdown
# Rails upgrade: CURRENT to TARGET

## Environment and baseline
Current and target Rails patches, Ruby versions, framework defaults, bundle selection, test commands/results, and unavailable checks.

## Upgrade path
Ordered release-series hops, Ruby prerequisites, and the next bounded implementation step.

## Findings
| Finding | File and line | Observed behavior | Official source | Proposed change | Verification |
| --- | --- | --- | --- | --- | --- |

## Dependencies and configuration
Required dependency constraints, reviewed lockfile changes, configuration preview, optional choices, and deferred defaults.

## Verification and rollout
Current/target bundle results, affected user flows, remaining uncertainty, deployment compatibility, and rollback limits.
```

## Configuration preview

```markdown
# Configuration preview: CURRENT to TARGET

Evidence: exact app:update result from an isolated app copy, or a proposed diff based on official generator changes.

| File | Required or optional | Proposed change | Existing customization | Reason and source |
| --- | --- | --- | --- | --- |

Include the relevant actual diffs, unresolved decisions, framework-default transition plan, and checks needed before applying the changes.
```

For completion, include the actual installed versions and test results. State separately whether changes were committed, deployed, or verified in production. A successful resolver, pattern scan, or boot command does not establish full upgrade success.
