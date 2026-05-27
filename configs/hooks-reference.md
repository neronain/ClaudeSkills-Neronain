# Claude Code Hooks

Predefined hooks for automation and optimization.

## Available Hooks

### RTK Rewrite Hook
Automatically wraps bash commands with RTK for token savings.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/tananan/.claude/hooks/rtk-rewrite.sh"
          }
        ]
      }
    ]
  }
}
```

### Pre-Task Hook
Runs before any tool use - useful for context capture.

```bash
#!/bin/bash
# Pre-task hook example
echo "[PRE-TASK] $(date): Claude starting task"
```

### Post-Task Hook
Runs after task completion - useful for notifications.

```bash
#!/bin/bash
# Post-task hook example
echo "[POST-TASK] $(date): Task completed"
```

### Git Hook Integration
Automatically commit CLAUDE.md updates.

```bash
#!/bin/bash
# .githooks/pre-commit
if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Commit CLAUDE.md if changed
if git diff --cached --name-only | grep -q "CLAUDE.md"; then
    echo "Auto-committing CLAUDE.md update"
    git add CLAUDE.md
fi
```

## Hook Events

| Event | Description |
|-------|-------------|
| PreToolUse | Before any tool execution |
| PreTask | Before task execution |
| PostTask | After task completion |
| PreCommit | Before git commit |
| PostCommit | After git commit |

## Setup

1. Place hook scripts in `~/.claude/hooks/`
2. Make them executable: `chmod +x ~/.claude/hooks/*`
3. Configure in `settings.json`

## Example: Alert Hook

```bash
#!/bin/bash
# ~/.claude/hooks/alert-on-cost.sh
TOKENS=$(cat "$CLAUDE_TOKEN_USAGE_FILE" 2>/dev/null || echo "0")
if [ "$TOKENS" -gt 100000 ]; then
    echo "⚠️ High token usage: $TOKENS"
fi
```