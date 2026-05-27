# RTK Rewrite Hook

Automatically wraps bash commands with RTK for token savings.

## Installation

### Step 1: Copy Hook Script

```bash
mkdir -p ~/.claude/hooks
cp ~/.claude/plugins/ClaudeSkills-Neronain/hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

### Step 2: Configure in `~/.claude/settings.json`

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
| `git log` | `rtk git log` |
| `npm list` | `rtk pnpm list` |
| `pnpm list` | `rtk pnpm list` |
| `yarn list` | `rtk pnpm list` |
| `ls` | `rtk ls` |
| `find` | `rtk find` |
| `docker ps` | `rtk docker ps` |
| `kubectl get` | `rtk kubectl get` |

## Excluded Commands

These commands execute raw (no RTK wrapping):

| Command Type | Examples | Reason |
|--------------|----------|--------|
| Package install | `npm install`, `npm run`, `yarn install` | Need full output |
| Git write ops | `git commit`, `git push` | Interactive prompts |
| System commands | `sudo`, `ssh`, `scp`, `rsync` | System level |
| Shell builtins | `eval`, `source`, `exec` | Shell internals |

## Token Savings

| Command | Original Output | RTK Output | Savings |
|---------|-----------------|------------|---------|
| `git status` | ~1500 tokens | ~300 tokens | 80% |
| `npm list` | ~5000 tokens | ~1000 tokens | 80% |
| `find` | ~2000 tokens | ~400 tokens | 80% |
| `docker ps` | ~1000 tokens | ~200 tokens | 80% |

## Testing

### Test Hook Manually

```bash
# Test hook output
bash ~/.claude/hooks/rtk-rewrite.sh "git status"
# Expected: rtk git status

bash ~/.claude/hooks/rtk-rewrite.sh "npm install"
# Expected: npm install (raw - no wrapping)
```

### Test in Claude Code

1. Open Claude Code
2. Run: `git status`
3. Watch for transparent RTK rewrite

## Customization

### Add Custom Exclusions

Edit `~/.claude/hooks/rtk-rewrite.sh` and add to `EXCLUDED_COMMANDS`:

```bash
EXCLUDED_COMMANDS="npm install|npm run|git commit|git push|sudo|ssh|scp|rsync|eval|source|exec|your-custom-cmd"
```

### Add Custom Mappings

Add to the `COMMAND_MAP` in the hook script:

```bash
declare -A COMMAND_MAP=(
    ["git status"]="rtk git status"
    ["npm list"]="rtk pnpm list"
    # Add custom mappings:
    ["custom-cmd"]="rtk custom-cmd"
)
```

## Troubleshooting

### Hook not triggering

1. Check `settings.json` is valid JSON
2. Verify hook path exists and is executable
3. Check Claude Code version supports hooks (4.5+)

### Hook causing errors

1. Verify script is executable: `ls -la ~/.claude/hooks/rtk-rewrite.sh`
2. Check for syntax errors: `bash -n ~/.claude/hooks/rtk-rewrite.sh`
3. Test manually: `bash ~/.claude/hooks/rtk-rewrite.sh "test"`

### RTK not installed

1. Verify RTK is installed: `which rtk`
2. Check version: `rtk --version`
3. If missing, install from source or alternatives

## Performance

The hook is designed to be fast (<1ms execution):
- Simple bash only (no external dependencies)
- String matching only (no file I/O during execution)
- No network calls

## Integration with Other Tools

### With Statusline

The hook works alongside `statusline.sh` for real-time token tracking.

### With Link Scripts

After updating hooks, re-run link scripts:

```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
./scripts/link-skills.sh
```

## References

- [RTK Documentation](https://github.com/user/rtk)
- [Claude Code Hooks](https://code.claude.com/docs/docs/use-hooks)
- [Settings Configuration](../configs/hooks-reference.md)
