# Claude Code Hooks

Hooks are automation scripts that run at specific points in the Claude Code workflow.

## Supported Hook Events

| Event | Description | Trigger |
|-------|-------------|---------|
| PreToolUse | Before any tool execution | Every tool call |

## RTK Rewrite Hook

Automatically wraps bash commands with RTK for token savings.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/plugins/ClaudeSkills-Neronain/hooks/rtk-rewrite.sh"
          }
        ]
      }
    ]
  }
}
```

### How It Works

The hook intercepts bash commands and rewrites them to use RTK:

| Original Command | RTK Rewritten | Savings |
|------------------|---------------|---------|
| `git status` | `rtk git status` | ~80% |
| `npm list` | `rtk pnpm list` | ~80% |
| `pnpm list` | `rtk pnpm list` | ~80% |
| `ls` | `rtk ls` | ~80% |
| `find` | `rtk find` | ~80% |

### Excluded Commands

These commands execute raw (no RTK wrapping):
- `npm install`, `npm run` - Need full output
- `yarn install`, `yarn run` - Need full output
- `git commit`, `git push` - Interactive
- `sudo`, `ssh`, `scp`, `rsync` - System commands
- `eval`, `source`, `exec` - Shell builtins

## Custom Hook Examples

### Pre-Task Context Capture

```bash
#!/bin/bash
# Save context before tool execution
echo "[$(date)] PreToolUse: $@" >> ~/.claude/hooks/pre-task.log
```

### Post-Task Notification

```bash
#!/bin/bash
# Send notification after task completion
echo "[$(date)] Task completed: $@" >> ~/.claude/hooks/post-task.log
```

### Git Hook Integration

```bash
#!/bin/bash
# .githooks/pre-commit - Auto-commit CLAUDE.md updates
if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

if git diff --cached --name-only | grep -q "CLAUDE.md"; then
    echo "Auto-committing CLAUDE.md update"
    git add CLAUDE.md
fi
```

## Setup Guide

### 1. Create Hook Directory

```bash
mkdir -p ~/.claude/hooks
```

### 2. Copy Hook Script

```bash
cp ~/.claude/plugins/ClaudeSkills-Neronain/hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

### 3. Add to Settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/rtk-rewrite.sh"
          }
        ]
      }
    ]
  }
}
```

### 4. Verify

```bash
# Test hook
bash ~/.claude/hooks/rtk-rewrite.sh "git status"
# Should output: rtk git status
```

## Hook Patterns

### Pattern 1: Logging All Commands

```bash
#!/bin/bash
echo "[$(date)] CMD: $@" >> ~/.claude/hooks/audit.log
"$@"
```

### Pattern 2: Error Tracking

```bash
#!/bin/bash
if ! "$@"; then
    echo "[$(date)] FAILED: $@" >> ~/.claude/hooks/errors.log
fi
```

### Pattern 3: Resource Monitoring

```bash
#!/bin/bash
MEM_BEFORE=$(ps aux | grep -c $$)
"$@"
MEM_AFTER=$(ps aux | grep -c $$)
echo "[$(date)] MEM: ${MEM_BEFORE} -> ${MEM_AFTER}" >> ~/.claude/hooks/mem.log
```

## Best Practices

- **Keep hooks small** - Simple scripts run faster
- **No interactive prompts** - Hooks must run non-interactively
- **Error handling** - Always handle failures gracefully
- **Log output** - Keep audit logs for debugging
- **Test hooks** - Verify hooks work before adding to production
- **Use absolute paths** - Hooks may run from any working directory

## Troubleshooting

### Hook not triggering

1. Check `settings.json` syntax is valid JSON
2. Verify hook path is correct and executable
3. Check Claude Code logs for errors

### Hook causing slow execution

1. Remove heavy operations from hooks
2. Use simple log statements only
3. Test hook performance standalone

### Hook fails silently

1. Add error handling: `set -e` at top of script
2. Log to file: `echo "ERROR" >> /tmp/hook-debug.log`
3. Check file permissions: `chmod +x hook.sh`
