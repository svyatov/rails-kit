# Configuration and updates

Use the installed release's `bin/rails hyperdrive:init --help` and `bin/rails hyperdrive:sync --help` when its behavior differs from the [recorded baseline](sources.md).

## Agent hosts

### Claude Code

Hyperdrive writes a Streamable HTTP entry in the project `.mcp.json`. Open Claude Code in the Rails root, accept its normal project MCP trust prompt, and reconnect after configuration changes. Use the generated Layered Rails command names, such as `/layered-rails-review`; plugin installations use a different namespace.

Guidelines enter context through `CLAUDE.md` importing `.claude/hyperdrive/index.md`, which imports guideline files. With no guidelines, an absent import chain is expected. Skills load separately on demand.

### Codex

Hyperdrive does not generate Codex configuration. Merge an entry into the Rails project's `.codex/config.toml`, preserving other settings, and substitute the actual endpoint:

```toml
[mcp_servers.rails_hyperdrive]
url = "http://127.0.0.1:3000/_hyperdrive/mcp"
```

Project configuration requires a trusted project. Reconnect the client and inspect its active MCP tools. Prefer project configuration for this app; a global server entry can point other projects at the wrong running application. See [official MCP configuration](https://developers.openai.com/codex/mcp).

The generated `.claude/` agents, slash commands, and `CLAUDE.md` imports are not native Codex registrations. For portable companion content, add a concise pointer in the existing `AGENTS.md` naming the installed skill path and when to read it, including its referenced workflows. Verify it by loading the skill from that path. This provides explicit file-based use, not automatic skill discovery or Claude agent/command registration. If native discovery is required, use the current host-supported project skill location with one maintained copy or supported link, and verify discovery separately.

### Other clients

Use the host's documented Streamable HTTP configuration with the same local endpoint. Verify its native content format separately. A working MCP connection does not register `.claude/` commands or import `CLAUDE.md`. If the client runs on another machine or in a hosted service, report the loopback reachability limit; do not publish this unauthenticated endpoint.

## Custom endpoint

`bin/rails hyperdrive:init --mount-at /agent/hyperdrive` changes the generated mount and MCP URL. The path accepts slash-separated segments of letters, digits, underscores, and hyphens. The generated URL assumes port 3000; update client settings for the real port. If there is no standard `Rails.application.routes.draw do` anchor, init warns instead of mounting. Add the reported mount manually inside the application's route structure with its development guard, then verify it.

## Companion selection

```sh
bin/rails hyperdrive:discover
```

Discovery uses RubyGems metadata and the lockfile to suggest companions. It is read-only apart from a local cache, which lasts 24 hours; `--refresh` refreshes it. A suggestion is not an instruction to install. Inspect its upstream repository, installation instructions, and compatibility first, and add only content relevant to the requested setup. The article's Alba and Action Policy additions demonstrate matching; they are not setup dependencies. Its Sidekiq companion example is not a mandatory package.

Use the existing `.hyperdrive/config.yml` structure for preferences, then sync:

```yaml
disabled:
  skills: []
  guidelines: []
  agents: []
  commands: []
enabled: []
```

`disabled` contains artifact names, not paths. Disabling removes only unedited installed files; inspect reported modified leftovers. `enabled` contains names of already bundled gems whose top-level `skills/` content should be adopted despite lacking native Hyperdrive metadata. Review that content before opting in. Preserve the other config keys. `.hyperdrive/lock.yml` is engine-managed provenance, not a settings file.

## Updates

1. After an authorized gem change, preview `bin/rails hyperdrive:sync --dry-run`, then run `bin/rails hyperdrive:sync`. The Bundler plugin only adds missing artifacts; it defers rewrites and removals, and does not run in CI, frozen bundles, or non-development environments. A successful bundle is not evidence that all content is current.
2. Review the diff, untracked files, skipped artifacts, and guideline import chain. Check for new references, stale content, and path collisions. Sync updates untouched files and preserves local edits. Keep deliberate removals from `CLAUDE.md` and the guideline index; sync respects them.
3. For a locally modified file with an upstream update, choose a preservation strategy: `--sidecar` writes upstream beside it as `.new`, or `--merge` attempts a three-way merge and falls back to a sidecar. Review semantics after a clean merge. Reconcile each `.new` with the live file before deleting the sidecar; leave unresolved pairs visible. `--overwrite` discards local edits and requires explicit approval for the affected files.
4. Restart the development server after bundle or content changes before rechecking MCP resources. The stack profile is cached per process, and installed skill resources are enumerated at boot. Recheck the client and any affected content.

### Optional resolver

Configure `resolve.command` only when the user requests automated sidecar resolution. It runs an external command with access to local content. Reuse an available, approved tool; no resolver is required for ordinary setup. The upstream example is:

```yaml
resolve:
  command: claude -p $PROMPT --allowedTools Read,Edit,Write
```

`bin/rails hyperdrive:sync --resolve` delivers sidecars and invokes that command; `--merge --resolve` tries Git first. `--dry-run` previews without invoking it. The resolver substitutes placeholders without a shell; `$PROMPT` carries the rendered instructions, `$LOCAL` and `$REMOTE` name the pair, and `$MERGED` is the live output path. A zero exit code is insufficient: the live file must change before the sidecar is removed. Review the diff even after a reported resolution. Never configure or call an unavailable CLI, or use `--overwrite` to clear unresolved work.
