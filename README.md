# Rails Kit

Rails-related skills for Claude Code and Codex. Each skill is an individually installable plugin.

## Skills

| Skill | Description |
| --- | --- |
| [hyperdrive](plugins/hyperdrive/skills/hyperdrive/SKILL.md) | Set up and maintain Rails Hyperdrive in a Rails project: development-only gems, companion skills, MCP access, and safe content sync. |

## Local installation

From this checkout, register the marketplace and install the skill with your agent's CLI.

### Claude Code

```sh
claude plugin marketplace add .
claude plugin install hyperdrive@svyatov-rails-kit
```

### Codex

```sh
codex plugin marketplace add .
codex plugin add hyperdrive@svyatov-rails-kit
```

After installation, ask your agent to set up or maintain Rails Hyperdrive in a Rails application. The skill includes host-specific configuration and verification steps.

## Structure

Each `plugins/<name>/` directory contains a plugin manifest and `skills/<name>/SKILL.md`, with supporting references where needed. `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` expose the same plugins to Claude Code and Codex.

## Origin

The first skill, `hyperdrive`, was copied from `rails-hyperdrive` on the `feat/rails-hyperdrive-skill` branch of [Agent Toolkit](https://github.com/svyatov/agent-toolkit), commit `3edcfa830c1c038dc2691746d27542fd6fbf63f2`. Its instructions and references are unchanged apart from the skill name. Plugin repository links and marketplace metadata identify Rails Kit.

## License

[MIT](LICENSE)
