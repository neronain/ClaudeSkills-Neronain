# Working in this repo

This repo is the source of truth for my Claude Code environment. Everything here is
copied into `~/.claude/` by `scripts/link-skills.sh`, so a mistake lands on every
machine I use.

## Layout

Skills live in bucket folders under `skills/`:

| Bucket | For |
|---|---|
| `engineering/` | Writing, reviewing, testing, documenting code |
| `web/` | Performance, accessibility, SEO, Core Web Vitals |
| `ruflo/` | Skills that drive the Ruflo plugin suite |
| `hookify/` | Creating and managing behaviour-blocking hooks |
| `nvidia/` | RAG Blueprint, NeMo, AI-Q, Nemotron, DGX Spark |
| `productivity/` | Non-code workflow: comms, context hygiene, SaaS |
| `misc/` | Kept around, used occasionally |
| `personal/` | Tied to my own machines — never promoted |
| `in-progress/` | Drafts not ready to ship |
| `deprecated/` | No longer used |

A directory is a **bucket** when it has no `SKILL.md` of its own but contains
children that do. Nothing is hardcoded — adding `skills/newbucket/` works
immediately, but give it an entry in `BUCKET_TITLES` in `scripts/gen-docs.py` so its
README gets a real title instead of a guess.

## Rules

- Every skill in a public bucket must appear in `.claude-plugin/plugin.json` and in
  its bucket `README.md`. Both are **generated** — run `./scripts/gen-docs.py`, never
  hand-edit them.
- Skills in `personal/`, `in-progress/`, and `deprecated/` must appear in neither.
  `gen-docs.py` excludes them by name (`PRIVATE_BUCKETS`).
- The `description:` frontmatter in `SKILL.md` is the single source of truth for what
  a skill does. Docs read from it; do not restate it by hand somewhere else.
- The top-level `README.md` is hand-written. It links buckets and highlights the
  handful of skills I actually reach for — it is not an exhaustive list.
- Skill names must link to their `SKILL.md` wherever they appear in docs.

## Vendored skills

`debug-mantra`, `post-mortem`, `scrutinize`, `management-talk`, `qwen-agent`, and
`qwenchance` come from [thananon/9arm-skills](https://github.com/thananon/9arm-skills).

Edit them **there**, not here. The copies in this repo exist so a fresh clone is
self-contained; `~/.claude/skills/<name>` symlinks to the upstream checkout on my
machine, and `link-skills.sh` refuses to overwrite a symlink for exactly that reason.

## The RTK hook

`hooks/rtk-rewrite.sh` is intentionally **not** installed by `link-skills.sh`. The
rewrite logic lives in the Rust binary (`rtk rewrite`, `src/discover/registry.rs`),
so the shell script is a thin delegator that rarely changes and is often newer on a
working machine than in this repo.

Before copying the repo version over a machine's version, compare
`# rtk-hook-version: N` on line 2. Newer wins. Changing rewrite rules means changing
the Rust registry, not this file.

## Before committing

```bash
./scripts/gen-docs.py --check      # manifest + bucket READMEs current?
bash -n scripts/link-skills.sh     # script still parses?
./scripts/link-skills.sh --dry-run # nothing surprising?
```

Never commit real tokens. `tools/mcp/*.json` are templates with placeholders — a
filled-in copy belongs in `~/.claude/settings.local.json`.
