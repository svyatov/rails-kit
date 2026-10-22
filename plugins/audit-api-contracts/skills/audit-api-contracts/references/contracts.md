# Contract checks for Rails APIs

## Schema authority

For a schema-first API, validate implementation against the agreed document. For an implementation-generated API, inspect the serializer metadata and request-spec coverage used by the generator. A generator can faithfully reproduce incomplete metadata, so generated output is not independent evidence of correctness.

Use the project's existing tools. Do not migrate all request specs to a new DSL or install a schema generator merely because an article uses one. When conversion is requested, preserve every relevant context, assertion, and error case; establish one representative conversion before scaling it.

## Presence, nullability, and shape

`required` means that a key must exist. It does not mean its value cannot be null. Conversely, allowing null does not permit a required key to disappear. Test omission and explicit null independently.

OpenAPI 3.0 represents a nullable string using `type: string` with `nullable: true`. OpenAPI 3.1 uses JSON Schema null types, for example `type: [string, "null"]`. Match the declared dialect and validator; do not copy the article's older hand-written conversion across versions.

Inspect nested arrays/objects, key transforms, enum values, numeric/string IDs, timestamps, conditional attributes, role-specific fields, and empty collections. Specify additional-property policy deliberately rather than assuming properties are exhaustive. Avoid making every property globally required as a shortcut.

Parameter metadata does not establish validation. Send malformed and missing inputs through actual requests. Assert the resulting status and error shape; include authentication and authorization cases. Sensitive fields excluded for one role must stay excluded when serializers are reused elsewhere.

## Rswag and Typelizer, when installed

Rswag's `run_test!` defines a request example and response validation. Its generation task can run in dry-run mode, producing documentation without executing requests. Confirm real examples ran by using the project's ordinary request-spec command and inspecting example counts/results.

For a compatible existing setup, the upstream commands include:

```sh
bundle exec rspec spec/requests
```

```sh
RSWAG_DRY_RUN=0 bundle exec rake rswag:specs:swaggerize
```

The second command writes schema artifacts. An audit-only run should use a disposable worktree/output destination if safely supported, or report the pending generation check. Do not rewrite tracked artifacts without authorization.

Rswag's checked response validator uses JSON Schema Draft 4 with extensions. Declaring an OpenAPI 3.1 document alone does not establish complete JSON Schema 2020-12 validation. Verify installed support before making claims about nullable unions or other dialect features.

Typelizer now supplies `Typelizer.openapi_schemas`, including `openapi_version:` and `writer_name:` options. Prefer its installed public API over recreating the article's custom converter. Match the schema's key naming to actual serializer output. Generated components do not establish endpoint paths, status codes, parameter validation, or authorization coverage.

## Drift and breaking changes

Use the normal generator deterministically and compare its output with tracked artifacts. Keep generated files scoped to the contract under review. A clean diff proves reproducibility only for covered inputs, not API completeness.

Compare compatibility against the last published or otherwise agreed schema, not an arbitrary local file. Treat removed endpoints/fields, newly required inputs, stricter enums, type changes, and changed authentication as possible breaks. Direction matters: request and response compatibility rules differ. Report consumer requirements and ambiguous changes rather than mechanically rejecting every schema diff.

If a schema linter or diff tool is already installed, use its supported dialect and options. Before recommending another tool, verify current upstream identity, installation, and compatibility. Keep the audit useful through manual evidence when no such tool exists.
