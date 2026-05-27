# RTK Rewrite Hook

Automatically wraps bash commands with RTK for token savings.

## Installation

1. Copy the hook script:
```bash
cp ~/.claude/plugins/ClaudeSkills-Neronain/hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

2. Configure in `~/.claude/settings.json`:
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

## How It Works

The hook intercepts bash commands and rewrites them to use RTK:

| Original Command | RTK Rewritten |
|------------------|---------------|
| `git status` | `rtk git status` |
| `npm list` | `rtk pnpm list` |
| `pnpm list` | `rtk pnpm list` |
| `ls` | `rtk ls` |
| `find` | `rtk find` |

## Custom Commands

Add custom command mappings in `~/.claude/hooks/rtk-commands.json`:

```json
{
  "git": "rtk git",
  "npm": "rtk pnpm",
  "pnpm": "rtk pnpm",
  "yarn": "rtk pnpm",
  "ls": "rtk ls",
  "find": "rtk find",
  "docker": "rtk docker"
}
```

## Token Savings

| Command | Original | RTK | Savings |
|---------|----------|-----|---------|
| `git status` | ~1500 | ~300 | 80% |
| `npm list` | ~5000 | ~1000 | 80% |
| `find` | ~2000 | ~400 | 80% |

## Exclusions

Some commands should NOT be wrapped:
- `npm install` - use raw
- `npm run` - use raw
- `git commit` - use raw
- `git push` - use raw