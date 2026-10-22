# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. The instructions are MIT licensed; source publications retain their own rights.

- [Let there be docs! A documentation-first approach to Rails API development](https://evilmartians.com/chronicles/let-there-be-docs-a-documentation-first-approach-to-rails-api-development), Svyatoslav Kryukov and Travis Turner, Evil Martians, 2024: contract authority and request validation.
- [Let there be docs! Generating an OpenAPI schema across the Rails stack](https://evilmartians.com/chronicles/let-there-be-docs-generating-openapi-schema-across-rails-stack), Andrey Novikov and Travis Turner, Evil Martians, 2025, updated 2026: serializers, generated components, request-spec conversion, drift, and compatibility checking.
- [OpenAPI 3.0.4 Schema Object](https://spec.openapis.org/oas/v3.0.4.html#schema-object) and [OpenAPI 3.1.1 data types](https://spec.openapis.org/oas/v3.1.1.html#data-types): presence, nullability, and dialect differences.
- [Action Controller Strong Parameters](https://guides.rubyonrails.org/action_controller_overview.html#strong-parameters) and [Rails CSRF countermeasures](https://guides.rubyonrails.org/security.html#csrf-countermeasures): native request protection, attribute allowlists, and authentication-specific CSRF handling.
- [Rswag upstream](https://github.com/rswag/rswag), [request example implementation](https://github.com/rswag/rswag/blob/master/rswag-specs/lib/rswag/specs/example_group_helpers.rb), [response validator](https://github.com/rswag/rswag/blob/master/rswag-specs/lib/rswag/specs/response_validator.rb), and [generation task](https://github.com/rswag/rswag/blob/master/rswag-specs/lib/tasks/rswag-specs_tasks.rake): runtime validation and dry-run generation are separate evidence.
- [Typelizer OpenAPI guide](https://github.com/skryukov/typelizer/blob/main/docs/guides/openapi.md): current public schema-generation options. The hand-built converter in the article predates this public API.

These sources inform an audit of the application's existing stack. Recheck installed tool versions and serializer support before using examples. No generator, linter, diff tool, or framework migration is required by default.
