# Rails Kit

Rails-related skills for Claude Code and Codex. Each skill is an individually installable plugin.

## Skills

| Skill | Description |
| --- | --- |
| [hyperdrive](plugins/hyperdrive/skills/hyperdrive/SKILL.md) | Set up and maintain Rails Hyperdrive in a Rails project: development-only gems, companion skills, MCP access, and safe content sync. |

## Installation

Register the marketplace and install the skill with your agent's CLI.

### Claude Code

```sh
claude plugin marketplace add svyatov/rails-kit
claude plugin install hyperdrive@rails-kit
```

### Codex

```sh
codex plugin marketplace add svyatov/rails-kit
codex plugin add hyperdrive@rails-kit
```

After installation, ask your agent to set up or maintain Rails Hyperdrive in a Rails application. The skill includes host-specific configuration and verification steps.

To install from a local checkout, run these commands from its root and replace `svyatov/rails-kit` with `.` in the marketplace command.

## Structure

Each `plugins/<name>/` directory contains a plugin manifest and `skills/<name>/SKILL.md`, with supporting references where needed. `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` expose the same plugins to Claude Code and Codex.

## License

[MIT](LICENSE)
