# Sources and compatibility

Original Rails Kit instructions, checked 2026-10-23. These instructions are MIT licensed; linked articles and documentation retain their own rights.

- [Custom cops for RuboCop](https://evilmartians.com/chronicles/custom-cops-for-rubocop-an-emergency-service-for-your-codebase), Evil Martians, 2021: AST-based rule development and cop tests. Its base-class and configuration-injection examples are historical.
- [Writing custom RuboCop rules in 2026](https://evilmartians.com/chronicles/writing-custom-rubocop-rules-in-2026), Yaroslav Kurbatov and Travis Turner, Evil Martians, 2026: plugin packaging, target-version gates, safe navigation, and correction safety.
- [RuboCop development guide](https://docs.rubocop.org/rubocop/latest/development.html): public cop APIs, callbacks, tests, and correction.
- [NodePattern](https://docs.rubocop.org/rubocop-ast/latest/node_pattern.html): matcher and search semantics.
- [Plugins](https://docs.rubocop.org/rubocop/latest/plugins.html) and [plugin migration guide](https://docs.rubocop.org/rubocop/latest/plugin_migration_guide.html): extension packaging and continuing support for local `require` loading.

The 2026 article refers to RuboCop v2. The checked official documentation instead identifies the plugin introduction as 1.72 and documents `Base` as the current superclass. This skill follows upstream API documentation, not the article's version claim. Use documentation matching the target project's lockfile; a floating `latest` page is not evidence of installed capabilities.
