# Installation Guide

## Quick Start (Recommended)

```bash
# Clone the repo
git clone https://github.com/neronain/ClaudeSkills-Neronain.git ~/claude/ClaudeSkills-Neronain

# Install skills, agents, and commands
cd ~/claude/ClaudeSkills-Neronain
./scripts/link-skills.sh

# Restart Claude Code to load everything
```

## Detailed Installation Steps

### Step 1: Clone Repository

```bash
git clone https://github.com/neronain/ClaudeSkills-Neronain.git ~/claude/ClaudeSkills-Neronain
```

### Step 2: Install Skills, Agents, and Commands

```bash
cd ~/claude/ClaudeSkills-Neronain
./scripts/link-skills.sh
```

This installs to:
- `~/.claude/skills/` — 40+ skills
- `~/.claude/agents/` — 17 specialized agents
- `~/.claude/commands/` — 12 slash commands

To force-overwrite existing files (after a `git pull`):
```bash
./scripts/link-skills.sh --force
```

### Step 3: Install RTK Hook (Token Savings)

```bash
# Install rtk and jq (macOS)
brew install rtk jq

# Copy RTK hook to Claude hooks directory
mkdir -p ~/.claude/hooks
cp ~/claude/ClaudeSkills-Neronain/hooks/rtk-rewrite.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/rtk-rewrite.sh
```

Then add to `~/.claude/settings.json`:
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

### Step 4: Enable Ruflo Plugins (Optional)

If you have the Ruflo plugin system installed, add to `~/.claude/settings.json`:

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
  }
}
```

### Step 5: Restart Claude Code

Close and reopen Claude Code. Skills and agents are now available.

### Step 6: Verify Installation

```bash
# Check skills are installed
ls ~/.claude/skills/ | wc -l    # should show 40+

# Check agents are installed
ls ~/.claude/agents/ | wc -l    # should show 17

# Check commands are installed
ls ~/.claude/commands/ | wc -l  # should show 12
```

In Claude Code, try:
```
/ruflo-doctor
/discover-plugins
@fullstack-developer Hello
```

## Updating

```bash
cd ~/claude/ClaudeSkills-Neronain
git pull
./scripts/link-skills.sh --force
# Restart Claude Code
```

## Troubleshooting

### Skills not found after installation

- Verify files exist: `ls ~/.claude/skills/`
- Restart Claude Code (required after adding new skills)
- If using plugins, check `enabledPlugins` in `settings.json`

### RTK hook not working

```bash
which rtk     # verify rtk is in PATH
which jq      # verify jq is installed
rtk --version # should be >= 0.23.0
```

### Git clone fails

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Full Configuration Reference

See `configs/settings-snippet.json` for a complete `settings.json` example.

See `tools/mcp/` for MCP server configuration files (GitHub, Postgres, Exa, Slack, etc.).
