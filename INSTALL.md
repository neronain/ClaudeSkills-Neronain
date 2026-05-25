# Installation Guide

## Quick Start

```bash
cd ~/.claude/plugins
git clone https://github.com/neronain/ClaudeSkills-Neronain.git
```

Then enable in `settings.json` (see README.md for configuration).

## Detailed Installation Steps

### Step 1: Locate Your Claude Code Plugins Directory

The default locations:

- **macOS/Linux**: `~/.claude/plugins`
- **Windows**: `%APPDATA%\Claude\plugins` or `%USERPROFILE%\AppData\Roaming\Claude\plugins`

Verify the location:
```bash
ls -la ~/.claude/plugins
```

### Step 2: Clone This Repository

```bash
cd ~/.claude/plugins
git clone https://github.com/neronain/ClaudeSkills-Neronain.git
```

This creates `~/.claude/plugins/ClaudeSkills-Neronain/`

### Step 3: Configure Settings

Edit `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "ruflo-core@ruflo": true,
    "ruflo-swarm@ruflo": true,
    "ruflo-autopilot@ruflo": true,
    "ruflo-intelligence@ruflo": true,
    "ruflo-security-audit@ruflo": true,
    "ruflo-testgen@ruflo": true,
    "ruflo-docs@ruflo": true,
    "claude-code-settings@feiskyer/claude-code-settings": true
  },
  "extraKnownMarketplaces": {
    "ruflo": {
      "source": {
        "source": "directory",
        "path": "~/.claude/ruflo"
      },
      "autoUpdate": false
    },
    "neronain/ClaudeSkills-Neronain": {
      "source": {
        "source": "directory",
        "path": "~/.claude/plugins/ClaudeSkills-Neronain"
      },
      "autoUpdate": false
    }
  }
}
```

### Step 4: Restart Claude Code

Close and reopen Claude Code to load the new skills.

### Step 5: Verify Installation

Check that skills are available:
```bash
/claude-flow doctor
```

Or run any skill:
```bash
/discover-plugins
```

## Manual Plugin Setup (Alternative)

If you prefer not to use the marketplace configuration:

1. Copy skills to ruflo's skills directory:
```bash
cp -r ~/.claude/plugins/ClaudeSkills-Neronain/skills/* ~/.claude/ruflo/plugins/ruflo-core/skills/
```

2. Restart Claude Code

## Troubleshooting

### "Skill not found" error

- Verify the plugin is enabled in `settings.json`
- Check the directory structure: `ls -la ~/.claude/plugins/ClaudeSkills-Neronain/skills/`
- Restart Claude Code

### "MCP server not found" error

Install the ruflo MCP server:
```bash
npm install -g @claude-flow/cli
claude-flow mcp install
```

### Git clone fails

Check your git configuration:
```bash
git config --global user.name
git config --global user.email
```

## Updating

To update to the latest version:
```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
git pull
```
