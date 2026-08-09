# Subagents

17 specialist subagents, installed to `~/.claude/agents/`. Invoke with `@name`, or
let Claude pick one via the Agent tool.

A subagent runs in its own context window. That is the point: hand it a bounded job
("audit this module for injection risks", "design the Postgres schema for X") and
you get the conclusion back without the exploration filling your main conversation.

## Build

| Agent | Focus |
|---|---|
| [`@fullstack-developer`](fullstack-developer.md) | End-to-end application development with modern web technologies |
| [`@frontend-developer`](frontend-developer.md) | React/Vue/Angular, UI/UX, performance, accessibility |
| [`@backend-developer`](backend-developer.md) | Node.js/Python/Go, APIs, databases, microservices |
| [`@nextjs-developer`](nextjs-developer.md) | App Router, Server Components, API routes, optimization |

## Languages

| Agent | Focus |
|---|---|
| [`@typescript-pro`](typescript-pro.md) | Advanced type system, generics, utilities, enterprise patterns |
| [`@python-pro`](python-pro.md) | asyncio, decorators, generators, Pythonic patterns |
| [`@rust-engineer`](rust-engineer.md) | Ownership, borrowing, async, systems programming |

## Architecture & data

| Agent | Focus |
|---|---|
| [`@api-designer`](api-designer.md) | REST/GraphQL/WS design, OpenAPI, backend architecture |
| [`@architect-reviewer`](architect-reviewer.md) | System design review, architecture patterns, technical debt |
| [`@database-administrator`](database-administrator.md) | PostgreSQL, MySQL, MongoDB, query and index optimization |
| [`@llm-architect`](llm-architect.md) | Prompt engineering, RAG, agents, LLM application design |

## Operations

| Agent | Focus |
|---|---|
| [`@devops-engineer`](devops-engineer.md) | CI/CD, infrastructure as code, monitoring, cloud operations |
| [`@kubernetes-specialist`](kubernetes-specialist.md) | Clusters, deployments, services, K8s-native development |

## Security

| Agent | Focus |
|---|---|
| [`@security-auditor`](security-auditor.md) | Vulnerability scanning, compliance, security best practices |
| [`@penetration-tester`](penetration-tester.md) | Ethical hacking, vulnerability assessment, security testing |

> Both security agents assume an authorized context — your own systems, a scoped
> engagement, or a CTF. State the authorization when you invoke them.

## Process

| Agent | Focus |
|---|---|
| [`@project-manager`](project-manager.md) | Agile/Scrum, planning, tracking, team coordination |
| [`@productivity-specialist`](productivity-specialist.md) | Workflow optimization, automation, time management |

---

## Adding one

Drop `agents/<name>.md` with `name:` and `description:` frontmatter, add a row to the
table above, then run `./scripts/gen-docs.py` (picks it up into `plugin.json`) and
`./scripts/link-skills.sh --force`. Restart Claude Code.

The `description:` is what Claude matches against when choosing an agent — write it
as *when to use this*, not as a job title.
