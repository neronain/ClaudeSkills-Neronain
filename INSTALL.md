# Installation

## TL;DR

```bash
git clone https://github.com/neronain/ClaudeSkills-Neronain.git ~/claude/ClaudeSkills-Neronain
cd ~/claude/ClaudeSkills-Neronain
./scripts/link-skills.sh
```

Restart Claude Code. That installs 56 skills, 17 subagents, and 12 slash commands.
The RTK hook and Ruflo plugins are separate opt-in steps below.

Requirements: `bash`, `git`, `python3` (only for `gen-docs.py`). Works on macOS and
Linux. Nothing is compiled and nothing runs as root.

---

## Step 1 — Clone

```bash
git clone https://github.com/neronain/ClaudeSkills-Neronain.git ~/claude/ClaudeSkills-Neronain
```

Any path works; `~/claude/ClaudeSkills-Neronain` is what the other docs assume.

## Step 2 — Install skills, agents, commands

```bash
cd ~/claude/ClaudeSkills-Neronain
./scripts/link-skills.sh --dry-run   # see exactly what it would touch
./scripts/link-skills.sh
```

| Source | Destination |
|---|---|
| `skills/<name>/SKILL.md` | `~/.claude/skills/<name>/` |
| `skills/<bucket>/<name>/SKILL.md` | `~/.claude/skills/<name>/` |
| `agents/*.md` | `~/.claude/agents/` |
| `commands/*.md` | `~/.claude/commands/` |

Behaviour worth knowing:

- **Whole directories are copied**, so a skill's `references/` and `scripts/`
  subfolders survive. (The old version copied only top-level `*.md` and quietly
  dropped everything else.)
- **Existing files are skipped** unless you pass `--force`.
- **Symlinks are never overwritten.** If `~/.claude/skills/debug-mantra` points at
  `~/9arm-skills/...`, the installer leaves it alone and prints why. Update those
  through their own repo.
- Buckets are detected structurally — a directory with no `SKILL.md` but children
  that have one is a bucket. Add `skills/whatever/` and it just works.
- Override the target with `CLAUDE_HOME=/some/path ./scripts/link-skills.sh`.

## Step 3 — RTK hook (optional, big token saver)

The installer does **not** touch `~/.claude/hooks/`. Copy it deliberately:

```bash
# macOS
brew install rtk jq
# or: cargo install rtk

rtk --version   # must be >= 0.23.0
```

Before overwriting an existing hook, compare versions — line 2 of the script carries
`# rtk-hook-version: N`. A working machine is often ahead of this repo.

```bash
head -2 ~/.claude/hooks/rtk-rewrite.sh    # what you have now
head -2 hooks/rtk-rewrite.sh              # what the repo ships
```

If the repo is newer or you have nothing:

```bash
mkdir -p ~/.claude/hooks
cp hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

Then register it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/rtk-rewrite.sh" }
        ]
      }
    ]
  }
}
```

Verify it is live:

```bash
rtk gain          # token savings analytics
rtk gain --history
```

If `rtk gain` reports an unknown subcommand you have the wrong `rtk` — the name
collides with *Rust Type Kit*. Check `which rtk`.

## Step 4 — Ruflo plugins (optional)

The 9 skills in [`skills/ruflo/`](skills/ruflo/) drive the Ruflo plugin suite and
need the plugins themselves installed. Add to `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "ruflo-core@ruflo": true,
    "ruflo-swarm@ruflo": true,
    "ruflo-autopilot@ruflo": true,
    "ruflo-intelligence@ruflo": true,
    "ruflo-security-audit@ruflo": true,
    "ruflo-testgen@ruflo": true,
    "ruflo-docs@ruflo": true
  }
}
```

A complete reference file is in [`configs/settings-snippet.json`](configs/settings-snippet.json).

## Step 5 — MCP servers (optional)

[`tools/mcp/`](tools/mcp/) holds ready-made configs for GitHub, Postgres, Slack,
Notion, Exa, Perplexity, Google Search, and Google Maps.

**Every one of them expects a token you supply yourself.** Never commit a filled-in
copy — put real values in `~/.claude/settings.local.json` or an env var, not here.

## Step 6 — Verify

```bash
ls ~/.claude/skills   | wc -l    # 56
ls ~/.claude/agents   | wc -l    # 17
ls ~/.claude/commands | wc -l    # 12
```

In Claude Code, restart, then try `/debug-mantra`, `/scrutinize`, or `@backend-developer`.

---

## Updating

```bash
cd ~/claude/ClaudeSkills-Neronain
git pull
./scripts/link-skills.sh --force
```

Upstream-vendored skills (`debug-mantra`, `post-mortem`, `scrutinize`,
`management-talk`, `qwen-agent`, `qwenchance`) come from
[thananon/9arm-skills](https://github.com/thananon/9arm-skills). To refresh those:

```bash
cd ~/9arm-skills && git pull
cd ~/claude/ClaudeSkills-Neronain
cp -R ~/9arm-skills/skills/engineering/*   skills/engineering/
cp -R ~/9arm-skills/skills/productivity/*  skills/productivity/
./scripts/gen-docs.py
```

## Contributing a skill to this repo

1. Create `skills/<bucket>/<name>/SKILL.md` with `name:` and `description:` frontmatter.
2. Run `./scripts/gen-docs.py` — it rewrites `plugin.json` and the bucket README.
3. Add a line to the top-level `README.md` only if it belongs in "ones I reach for most".
4. `./scripts/link-skills.sh --force` and restart Claude Code to try it.

Drafts go in `skills/in-progress/`, machine-specific things in `skills/personal/`.
Those buckets are excluded from the manifest and the docs on purpose.

---

## Troubleshooting

**Skill doesn't show up.** Restart Claude Code — new skills are read at startup.
Then check `ls ~/.claude/skills/<name>/SKILL.md` actually exists.

**`link-skills.sh: unknown flag`.** Only `--force`, `--dry-run`, and `--help` are
accepted; the script fails loudly rather than ignoring a typo.

**Installer skipped a skill.** Either it already exists (use `--force`) or it is a
symlink (intentional — see step 2).

**RTK hook does nothing.** `which rtk`, `which jq`, `rtk --version` (need ≥ 0.23.0).
The hook warns on stderr and exits 0 when any of those fail, so commands still run.

**`gen-docs.py --check` fails in CI.** Docs are stale — run `./scripts/gen-docs.py`
and commit the result.
