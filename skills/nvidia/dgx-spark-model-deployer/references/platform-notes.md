# Platform Notes

## Claude Code

- Personal: `~/.claude/skills/<name>/SKILL.md`
- Project: `.claude/skills/<name>/SKILL.md`
- Supports frontmatter such as `when_to_use`, `argument-hint`, and tool controls.
- Keep destructive commands approval-gated.

## OpenClaw

- Workspace: `~/.openclaw/workspace/skills/<name>/SKILL.md`
- Use `{baseDir}` for skill-local assets.
- Keep dependencies and sandbox requirements explicit.
- Restart or refresh the gateway/session when discovery is stale.

## Hermes

- Primary directory: `~/.hermes/skills/<name>/SKILL.md`
- Compatible with the Agent Skills standard.
- Uses progressive disclosure; keep `SKILL.md` focused and references modular.
- Platform and Hermes metadata can control discovery.
