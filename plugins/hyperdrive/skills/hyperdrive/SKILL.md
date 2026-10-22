---
name: hyperdrive
description: "Set up and maintain Rails Hyperdrive in a Rails project: development-only gems, companion skills, MCP access, and safe content sync."
license: MIT
disable-model-invocation: true
compatibility: Requires a Rails application, Ruby, Bundler, git, and network access for upstream checks and gem installation. MCP verification requires a local development server and an MCP client.
---

# Rails Hyperdrive

Configure an existing Rails application for agent development with Rails Hyperdrive. The default full setup includes the engine, the article's `layered-rails-skills` companion, and a working connection from the user's agent. Respect requests for MCP-only, content-only, or another companion. Creating an application, changing its architecture, and publishing companion gems are separate tasks.

Preserve the application's Rails layout, autoloading, environment configuration, and established generator conventions. Companion architecture guidance is optional project policy, not official Rails policy: installing it does not authorize restructuring the application. Resolve any conflict with the installed Rails version's documented behavior before applying companion advice.

This is an original setup workflow based on the Evil Martians article and checked against upstream documentation. See [sources and version baseline](references/sources.md). Read [configuration and updates](references/configuration.md) when selecting a host, customizing settings, or maintaining an existing installation.

## 1. Inspect the application and scope

Locate the Rails root and read its instructions, `Gemfile`, `Gemfile.lock`, Ruby version, routes, development launcher, and git status. Inspect existing `.mcp.json`, `.hyperdrive/`, `.claude/`, `.codex/config.toml`, and agent instruction files before changing them. If no Rails application can be identified, ask for its path.

For an existing installation, check for legacy content preferences and follow the migration in [configuration and updates](references/configuration.md#updates) before changing the bundle or running init/sync.

Identify the agent host, requested setup mode, development URL, and companions already installed through gems or plugins. Reuse existing choices. Ask only for decisions the repository and request do not establish. Avoid duplicate Layered Rails installations through both a plugin and Hyperdrive.

Check the current [upstream README](https://github.com/rails-hyperdrive/rails-hyperdrive) and gemspec before installation. The recorded baseline requires Ruby 3.2+ and Rails 7.2+; confirm the chosen release's requirements. If the app is incompatible, report the mismatch instead of upgrading Rails or Ruby as part of setup.

Done when the application, host, mode, compatible dependencies, and, if needed, development endpoint are known.

## 2. Install the development dependencies

For the full article setup, use the upstream installation command, adding only gems that are missing:

```sh
bundle add rails-hyperdrive layered-rails-skills --group=development
```

For MCP-only setup, add only `rails-hyperdrive`. Preserve existing version constraints and keep these dependencies in the development group. Read each companion's upstream README and gemspec to verify its identity and compatibility before adding it. Hyperdrive provides the engine; it ships no agent guidance itself.

Run Bundler through the project's normal Ruby environment. Review `Gemfile.lock` for unrelated upgrades. If resolution fails, identify the dependency conflict; do not remove constraints or switch gem sources to force installation.

Done when Bundler resolves the requested development gems without unrelated dependency changes.

## 3. Initialize and review the generated configuration

Run setup and sync in the development environment. For the default setup:

```sh
bin/rails hyperdrive:init --dry-run
bin/rails hyperdrive:init
bundle install
```

Use `--skip-content` for MCP-only setup, or `--skip-mcp` for content-only setup, on both init commands. These flags skip creation; they do not remove an earlier installation. `bundle install` after init activates the generated `bundler-hyperdrive` plugin declaration. For an initialized app that only needs content refreshed, use the update procedure in [configuration and updates](references/configuration.md#updates), not another bootstrap run.

Review the dry run before applying it. Inspect the resulting diff and untracked files: development gems and lockfile, Bundler plugin declaration, guarded route, MCP configuration, `.hyperdrive/config.yml`, `.hyperdrive/lock.yml`, and installed companion files. MCP-only setup skips the content config and lock. Preserve unrelated MCP servers and local instructions; verify the existing Hyperdrive URL because reinitializing can reset it.

Keep the engine mount guarded by `Rails.env.development?`. Keep the development server on loopback. Hyperdrive has no authentication, and `run_ruby` executes arbitrary Ruby with the application's access. Its SQL filter and origin checks do not make it a sandbox. Do not expose the endpoint through a public listener or tunnel to make an agent connect.

Content installation currently targets `.claude/skills/`, `.claude/agents/`, `.claude/commands/`, and, when guidelines exist, `.claude/hyperdrive/` plus an import in `CLAUDE.md`. Compare installed artifacts with the selected companions and actual bundle; counts in the article are examples. Keep generated content and `.hyperdrive/` settings and lock tracked. Only the discovery cache belongs in the generated ignore rule.

Done when every generated change is understood, local content is preserved, and, for MCP-enabled setups, the route and client agree on the endpoint.

## 4. Connect and verify the agent

Follow the host section in [configuration and updates](references/configuration.md#agent-hosts). For MCP-enabled setups, use an existing local development server or start one with the project's launcher and an explicit loopback binding. For a standard Rails launcher:

```sh
bin/rails server -b 127.0.0.1
```

Use the actual host, port, and mount path in this transport check:

```sh
curl --fail-with-body --silent --show-error http://127.0.0.1:3000/_hyperdrive/mcp \
  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

Check the JSON-RPC response for errors, not only the HTTP status. Then connect through the actual agent client and call `describe_app` and `list_routes`. Match the returned versions and an application route to this checkout; an open port can belong to another app. Confirm the client exposes the expected tools. For setups with companion content, also load an installed skill and its supporting references. Do not use Ruby eval or mutating application actions as smoke tests.

For content-only setup, verify skill loading and reference resolution without starting an MCP server. Run the repository's applicable configuration checks, and review the route and Gemfile to confirm development-only loading. If the client cannot reload during this session, report the transport check separately and give the exact remaining client check. Do not call the integration verified until it has run through the client.

Done when the requested content is usable and the requested MCP connection reaches this application, or the remaining verification is explicitly identified.

## 5. Leave a maintainable setup

Explain the installed companions, how to start the local server, the client endpoint, and any host-specific limitations. For future bundle changes, document `bin/rails hyperdrive:sync` and the local-edit procedure in [configuration and updates](references/configuration.md#updates). Report unresolved sidecars, skipped artifacts, and verification gaps. Stop only servers started for this verification, unless the user wants one left running. Commit or publish only within the task's authorization.
