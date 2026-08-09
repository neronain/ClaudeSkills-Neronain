# Slash commands

12 commands, installed to `~/.claude/commands/`. Each takes `$ARGUMENTS` — a file
path, route, component name, or a plain-English description.

## Frontend

| Command | Does | `$ARGUMENTS` |
|---|---|---|
| [`/ui`](ui.md) | Generate a polished React + Next.js + Tailwind component | what to build |
| [`/ux`](ux.md) | UX/UI review and improvement pass | component or page |
| [`/design`](design.md) | Full-page design audit, then apply the fixes | page or component |
| [`/responsive`](responsive.md) | Make it work across every breakpoint | component or page |
| [`/a11y`](a11y.md) | WCAG 2.1 AA audit and fix | file |

## Backend & data

| Command | Does | `$ARGUMENTS` |
|---|---|---|
| [`/api`](api.md) | Scaffold a production-ready App Router API route | description |
| [`/db`](db.md) | Prisma + PostgreSQL schema, query, or migration help | task |

## Quality

| Command | Does | `$ARGUMENTS` |
|---|---|---|
| [`/test`](test.md) | Write comprehensive tests | file or function |
| [`/debug`](debug.md) | Systematic root-cause hunt | error or symptom |
| [`/refactor`](refactor.md) | Clarity refactor, behaviour preserved | file or function |
| [`/perf`](perf.md) | Web performance audit and fix | file or route |
| [`/deploy`](deploy.md) | Pre-deployment checklist | optional feature/PR |

---

## Stack assumptions

These were written against a Next.js + Prisma + PostgreSQL + Vitest project.
`/api`, `/db`, `/test`, and `/deploy` name that stack explicitly — `/deploy` still
mentions the original project by name. Read the command file and adjust before using
them on a plain Node, Python, or Go repo.

The frontend commands (`/ui`, `/ux`, `/design`, `/responsive`, `/a11y`) assume React
+ Tailwind but degrade gracefully.

## Commands vs skills

A **command** is something you invoke by name when you already know what you want.
A **skill** is something Claude loads on its own when the work matches its
`description:`. If you find yourself typing the same command every time a situation
comes up, it probably wants to be a skill in [`../skills/`](../skills/) instead.

## Adding one

Drop `commands/<name>.md` — the body is the prompt, `$ARGUMENTS` is substituted at
call time. Add a row above, run `./scripts/gen-docs.py` and
`./scripts/link-skills.sh --force`, restart Claude Code.
