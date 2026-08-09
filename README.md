# ClaudeSkills-Neronain

My Claude Code setup, kept in one repo so a fresh machine is one `git clone` and one script away from the environment I actually work in.

| | Count | Where |
|---|---|---|
| **Skills** | 56 | [`skills/`](skills/) → `~/.claude/skills/` |
| **Subagents** | 17 | [`agents/`](agents/) → `~/.claude/agents/` |
| **Slash commands** | 12 | [`commands/`](commands/) → `~/.claude/commands/` |
| **Hooks** | 1 | [`hooks/`](hooks/) → `~/.claude/hooks/` (manual, see [INSTALL.md](INSTALL.md)) |
| **MCP configs** | 8 | [`tools/mcp/`](tools/mcp/) (reference only) |

```bash
git clone https://github.com/neronain/ClaudeSkills-Neronain.git ~/claude/ClaudeSkills-Neronain
cd ~/claude/ClaudeSkills-Neronain && ./scripts/link-skills.sh
```

Full steps, including the RTK hook and Ruflo plugins, are in **[INSTALL.md](INSTALL.md)**.

---

## Skills

Skills live in buckets. Each bucket has its own README listing every skill with a
one-line description — those are generated from the `description:` frontmatter, so
they never drift from what Claude actually reads.

| Bucket | Skills | Covers |
|---|---|---|
| [engineering](skills/engineering/) | 19 | Code review, debugging discipline, testing, docs, dependency and security scans |
| [nvidia](skills/nvidia/) | 12 | RAG Blueprint, NeMo, AI-Q, Nemotron retrieval, DGX Spark deployment |
| [ruflo](skills/ruflo/) | 9 | Swarm init, autopilot loop, neural training, intelligence routing |
| [web](skills/web/) | 6 | Performance, accessibility, SEO, Core Web Vitals, full quality audit |
| [hookify](skills/hookify/) | 5 | Turn "stop doing that" into an enforced hook |
| [productivity](skills/productivity/) | 3 | Management-facing writing, context hygiene, SaaS connections |
| [misc](skills/misc/) | 2 | Cybersecurity AI (CAI), skill card generator |

### Ones I reach for most

| Skill | Why |
|---|---|
| [`debug-mantra`](skills/engineering/debug-mantra/SKILL.md) | Reproduce → trace the fail path → falsify the hypothesis → cross-reference. Stops guess-and-check debugging. |
| [`scrutinize`](skills/engineering/scrutinize/SKILL.md) | Outsider review of a plan or diff — questions the intent first, then traces the real code path. |
| [`post-mortem`](skills/engineering/post-mortem/SKILL.md) | Writes the canonical record of a fixed bug once it is actually fixed and validated. |
| [`qwen-agent`](skills/engineering/qwen-agent/SKILL.md) | Hands mechanical work (renames, boilerplate, log reading) to a cheap Qwen subagent instead of burning Claude quota. |
| [`qwenchance`](skills/productivity/qwenchance/SKILL.md) | Breaks a long task out of circular thinking and forces a clean handoff before the context window fills. |
| [`management-talk`](skills/productivity/management-talk/SKILL.md) | Rewrites engineer-to-engineer content for a VP / PM / release-manager audience, shaped per channel. |
| [`web-quality-audit`](skills/web/web-quality-audit/SKILL.md) | One pass over performance, a11y, SEO, and best practices. |
| [`dgx-spark-model-deployer`](skills/nvidia/dgx-spark-model-deployer/SKILL.md) | Verified deploy bundles for HF/NGC models on single or stacked DGX Sparks. |

`debug-mantra`, `post-mortem`, `scrutinize`, `management-talk`, `qwen-agent`, and
`qwenchance` are vendored from [thananon/9arm-skills](https://github.com/thananon/9arm-skills).
Upstream is the source of truth — see [Updating](#updating).

---

## Subagents

Invoke with `@name` or via the Agent tool.

| Agent | Focus |
|---|---|
| [`@fullstack-developer`](agents/fullstack-developer.md) | End-to-end app development |
| [`@frontend-developer`](agents/frontend-developer.md) | React/Vue/Angular, UI/UX, a11y |
| [`@backend-developer`](agents/backend-developer.md) | Node/Python/Go, APIs, microservices |
| [`@nextjs-developer`](agents/nextjs-developer.md) | App Router, Server Components, route handlers |
| [`@typescript-pro`](agents/typescript-pro.md) | Advanced types, generics, enterprise patterns |
| [`@python-pro`](agents/python-pro.md) | asyncio, decorators, generators |
| [`@rust-engineer`](agents/rust-engineer.md) | Ownership, borrowing, async, systems |
| [`@api-designer`](agents/api-designer.md) | REST/GraphQL/WS design, OpenAPI |
| [`@database-administrator`](agents/database-administrator.md) | PostgreSQL, MySQL, MongoDB, tuning |
| [`@devops-engineer`](agents/devops-engineer.md) | CI/CD, IaC, monitoring, cloud ops |
| [`@kubernetes-specialist`](agents/kubernetes-specialist.md) | Clusters, deployments, K8s-native design |
| [`@architect-reviewer`](agents/architect-reviewer.md) | System design review, technical debt |
| [`@security-auditor`](agents/security-auditor.md) | Vulnerability scanning, compliance |
| [`@penetration-tester`](agents/penetration-tester.md) | Ethical hacking, vulnerability assessment |
| [`@llm-architect`](agents/llm-architect.md) | Prompt engineering, RAG, agent design |
| [`@project-manager`](agents/project-manager.md) | Agile/Scrum, planning, tracking |
| [`@productivity-specialist`](agents/productivity-specialist.md) | Workflow optimization, automation |

---

## Slash commands

Each takes `$ARGUMENTS` — a file, route, component, or description.

| Command | Does |
|---|---|
| [`/ui`](commands/ui.md) | Generate a polished React + Tailwind component |
| [`/ux`](commands/ux.md) | UX/UI review and improvement pass |
| [`/design`](commands/design.md) | Full-page design audit, then apply the fixes |
| [`/responsive`](commands/responsive.md) | Make a component work across every breakpoint |
| [`/a11y`](commands/a11y.md) | WCAG 2.1 AA audit and fix |
| [`/perf`](commands/perf.md) | Web performance audit and optimization |
| [`/api`](commands/api.md) | Scaffold a Next.js App Router API route |
| [`/db`](commands/db.md) | Prisma + PostgreSQL schema, query, migration help |
| [`/test`](commands/test.md) | Write tests for a file or function |
| [`/debug`](commands/debug.md) | Systematic root-cause hunt for an error |
| [`/refactor`](commands/refactor.md) | Clarity refactor with behaviour preserved |
| [`/deploy`](commands/deploy.md) | Pre-deployment checklist |

> `/api`, `/db`, `/test`, and `/deploy` carry Next.js + Prisma + Vitest assumptions
> from the project they were written for. Adjust the stack lines before using them
> on a plain Node or Python repo.

---

## RTK hook

[`hooks/rtk-rewrite.sh`](hooks/rtk-rewrite.sh) is a `PreToolUse` hook for `Bash` that
rewrites commands to their [rtk](https://github.com/rtk-ai/rtk) equivalents, cutting
60–90% of the tokens a raw `git log` or `ls -R` would spend.

It is a **thin delegating hook** — every rewrite rule lives in the Rust binary
(`rtk rewrite`), not in the shell script, so the script rarely changes:

| `rtk rewrite` exit | Hook does |
|---|---|
| `0` + stdout | Rewrite found, no permission rule matched → rewrite and auto-allow |
| `1` | No RTK equivalent → pass the command through untouched |
| `2` | Deny rule matched → pass through, Claude Code's native deny handles it |
| `3` + stdout | Ask rule matched → rewrite, but let Claude Code prompt the user |

Requires `rtk >= 0.23.0` and `jq`. If either is missing the hook warns once on
stderr and exits cleanly — it never silently swallows a command.

`scripts/link-skills.sh` deliberately does **not** install this hook, because the
version on a working machine is often ahead of the repo. Copy it explicitly
(INSTALL.md step 3) and check `rtk-hook-version:` on line 2 before overwriting.

---

## Repo layout

```
.claude-plugin/plugin.json   generated manifest (skills + agents + commands)
agents/                      17 subagent definitions
commands/                    12 slash commands
configs/                     settings.json snippet, hook reference, RTK guide
hooks/rtk-rewrite.sh         RTK PreToolUse hook (v3)
scripts/link-skills.sh       installer  → ~/.claude/
scripts/gen-docs.py          regenerates plugin.json + bucket READMEs
scripts/update-from-github.sh
skills/<bucket>/<name>/SKILL.md
tools/mcp/*.json             MCP server configs (GitHub, Postgres, Exa, Slack, …)
tools/rtk/                   RTK notes and hook variants
```

---

## Updating

```bash
cd ~/claude/ClaudeSkills-Neronain
git pull
./scripts/link-skills.sh --force     # --dry-run first if unsure
```

`--force` never clobbers a symlink in `~/.claude/skills/` — if a skill points at
`~/9arm-skills`, the installer skips it and says so, so upstream stays upstream.

After adding or editing a skill:

```bash
./scripts/gen-docs.py       # refresh plugin.json + bucket READMEs
./scripts/gen-docs.py --check   # CI-friendly: exits 1 when docs are stale
```

Restart Claude Code to pick up new skills, agents, and commands.

---

## Conventions

See [CLAUDE.md](CLAUDE.md) — bucket rules, what must be documented, and what stays
out of the manifest.
