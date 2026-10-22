---
name: audit-api-contracts
description: 'Audit Rails API contracts against routes, request specs, serializers, and OpenAPI schemas. Use for response mismatches, undocumented errors, schema drift, or compatibility checks.'
license: MIT
compatibility: Requires a Rails API or its source artifacts. Use the installed serializer, schema generator, validator, and test runner; no particular OpenAPI tool is required.
---

# Audit API contracts

Compare the Rails API that callers receive with its declared contract. Report findings first; update code, tests, or generated schemas only when authorized. Exclude frontend client generation. See [sources](references/sources.md).

## 1. Establish the contract boundary

Read the requested routes, controllers, authorization, parameter handling, serializers, request specs, schema files, generator configuration, and CI commands. Record the Rails/tool versions and declared OpenAPI dialect.

Determine whether the project treats its schema as the design authority, generates it from implementation, or combines both approaches. Identify external consumers and compatibility requirements. Do not silently switch approaches or change the schema dialect.

Done when the endpoints, consumers, source of truth, and validation path are known, or missing decisions are explicitly listed.

## 2. Compare actual behavior

Read [contract checks](references/contracts.md). Trace and, where possible, exercise path/query/body inputs, success responses, failures, authentication, pagination, and conditional serializer output. Check media types, status codes, headers, field names, types, required keys, nullability, and enums.

Distinguish request construction, schema generation, and runtime validation. A generated document does not prove an endpoint was executed, and a happy-path response does not prove invalid input is rejected.

Done when each mismatch has source evidence or a request/spec result. Mark unexecuted checks as such.

## 3. Report compatibility and corrections

For each finding, give the endpoint, location, input or response example, declared versus observed behavior, affected consumers, proposed correction, and test. If the runner or consumer baseline is missing, describe the verification procedure and limitation instead of inventing evidence.

Do not assume the schema is wrong whenever it differs from code. A difference may be an implementation bug or an intentional change requiring coordination. Preserve existing request-spec contexts when proposing documentation-generating tests.

Done when findings distinguish runtime defects, documentation drift, and intentional breaking changes requiring a decision.

## 4. Verify authorized fixes

Execute real request specs, generate the schema using the project's command, validate the declared dialect, and inspect the diff. Compare with an actual consumer-facing baseline when compatibility is in scope. Add regeneration/drift checking to existing CI only when authorized by the task.

Verify at least the affected success and error paths, missing versus null fields, and conditional output. Report generated artifacts separately from executed tests and identify anything the validator cannot establish.
