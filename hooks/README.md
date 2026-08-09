# Hooks

## `rtk-rewrite.sh` — RTK token-saving hook

A `PreToolUse` hook on `Bash` that swaps commands for their
[rtk](https://github.com/rtk-ai/rtk) equivalents. `git log`, `ls -R`, `find`,
`docker ps`, `kubectl get` and friends return filtered output instead of thousands
of tokens of noise — typically 60–90% cheaper.

### It is a thin delegator, on purpose

All rewrite rules live in the Rust binary (`rtk rewrite`, backed by
`src/discover/registry.rs`). The shell script only translates exit codes into the
JSON Claude Code expects:

| `rtk rewrite` exit | Meaning | Hook response |
|---|---|---|
| `0` + stdout | Rewrite found, no permission rule matched | Rewrite the command and auto-allow |
| `1` | No RTK equivalent exists | Pass through unchanged |
| `2` | A deny rule matched | Pass through — Claude Code's native deny handles it |
| `3` + stdout | An ask rule matched | Rewrite, but omit the allow so the user is prompted |

**To add or change a rewrite rule, edit the Rust registry — not this script.**

### Version

Line 2 carries `# rtk-hook-version: N`. Bump it whenever the exit-code protocol or
the JSON shape changes, and compare before overwriting a machine's copy:

```bash
head -2 ~/.claude/hooks/rtk-rewrite.sh
head -2 hooks/rtk-rewrite.sh
```

Current: **v3** (delegating, with version guard and ask/deny protocol). v2 and
earlier hardcoded a bash command map and had no permission handling — if a machine
still runs one of those, the repo version is the upgrade.

### Requirements

- `rtk >= 0.23.0` — earlier builds have no `rtk rewrite` subcommand
- `jq`

Missing either? The hook prints one warning to stderr and exits 0. Commands still
run unmodified; nothing is silently swallowed.

### Install

Deliberately **not** handled by `scripts/link-skills.sh` — see
[INSTALL.md step 3](../INSTALL.md). Short version:

```bash
mkdir -p ~/.claude/hooks
cp hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

then register it under `hooks.PreToolUse` with `"matcher": "Bash"` in
`~/.claude/settings.json`.

### Checking it works

```bash
rtk gain            # cumulative token savings
rtk gain --history  # per-command breakdown
rtk discover        # commands you ran that RTK could have handled
```

`rtk proxy <cmd>` runs something raw, bypassing the filter — useful when you need
the real output for debugging.

### `.rtk-hook.sha256`

Integrity check for the installed hook. Regenerate after an intentional edit:

```bash
shasum -a 256 hooks/rtk-rewrite.sh > hooks/.rtk-hook.sha256
```

---

## Writing other hooks

[`../configs/hooks-reference.md`](../configs/hooks-reference.md) covers the event
types and JSON contract. Two things bite people:

- A hook that exits non-zero **blocks the tool call**. Exit 0 on every path you did
  not mean to block, including your own error paths.
- Hook stdout is fed back to Claude as tool feedback, so debug `echo`s become model
  input. Send diagnostics to stderr.
