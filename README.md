# ClaudeSkills-Neronain

My custom skills and configuration for Claude Code - All-in-one setup for Klassio LMS development.

## What's Included

This repository contains everything needed to set up Claude Code for Klassio LMS development:

| Component | Description |
|-----------|-------------|
| **9arm Skills** | Engineering & productivity skills (debug, review, docs) |
| **Ruflo Skills** | Advanced multi-agent workflows (swarm, autopilot, intelligence) |
| **feiskyer Skills** | Additional utilities (autonomous, codex, github tools) |
| **rtk CLI** | Token-optimized command wrapper (60-90% savings) |
| **Hooks** | Pre-tool hooks for command rewriting |

## Installation (New Machine)

### Step 1: Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install Dependencies

```bash
brew install rtk jq
```

### Step 3: Clone This Repository

```bash
cd ~/.claude/plugins
git clone https://github.com/neronain/ClaudeSkills-Neronain.git
```

### Step 4: Install 9arm Skills (Symlink)

```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
./scripts/link-skills.sh
```

### Step 5: Enable Plugins in `~/.claude/settings.json`

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
  },
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

### Step 6: Restart Claude Code

## Skills Overview

### 9arm Skills (4 skills) - Daily Workflow

| Skill | Category | When to Use |
|-------|----------|-------------|
| `/debug-mantra` | Engineering | Start any debugging session |
| `/scrutinize` | Engineering | PR review, code audit |
| `/post-mortem` | Engineering | Document bug fixes |
| `/management-talk` | Productivity | Convert tech content for leadership |

### Ruflo Skills (11 skills) - Advanced Workflows

| Skill | Description |
|-------|-------------|
| `init-project` | Initialize new projects with MCP tools |
| `ruflo-doctor` | Health checks and auto-repair |
| `swarm-init` | Multi-agent coordinated work |
| `autopilot-loop` | Autonomous task completion |
| `autopilot-predict` | Predict optimal next actions |
| `intelligence-route` | Neural task routing |
| `neural-train` | Train learned patterns |
| `security-scan` | Full security audits |
| `dependency-check` | CVE scanning |
| `tdd-workflow` | TDD London School |
| `doc-gen` | Documentation generation |

### feiskyer Skills (14 skills) - Utilities

- `autonomous-skill`, `codex-skill`, `command-creator`, `deep-research`
- `eureka`, `github-fix-issue`, `github-review-pr`, `gpt-image-skill`
- `kiro-skill`, `nanobanana-skill`, `reflection`, `skill-creator`
- `spec-kit-skill`, `translate`, `youtube-transcribe-skill`

## Usage

### Quick Start Commands

```bash
# Debugging
/debug-mantra

# Code Review
/scrutinize

# Documentation
/post-mortem

# Leadership Updates
/management-talk

# TDD
/tdd-workflow

# Documentation Gen
/doc-gen
```

### rtk Commands (Auto-Rewritten)

```bash
rtk git status      # Auto-rewritten to save tokens
rtk npx create-react-app
rtk npm install
```

## Project Structure

```
ClaudeSkills-Neronain/
├── skills/               # All skill directories
│   ├── engineering/     # Debug, review, docs
│   ├── productivity/    # Management, communication
│   ├── misc/            # Rarely used skills
│   └── ...
├── hooks/               # Pre-tool hooks
│   └── rtk-rewrite.sh   # Command rewriting
├── scripts/             # Utility scripts
│   ├── link-skills.sh   # Symlink skills to Claude
│   └── list-skills.sh   # List all available skills
├── CLAUDE.md           # Skill configuration rules
└── INSTALL.md          # Detailed installation guide
```

## Requirements

- **Node.js**: 20+
- **npm**: 9+
- **Git**: Latest
- **Homebrew**: Latest (for rtk)
- **rtk**: >= 0.23.0
- **Claude Code**: 4.5+

## Updating

```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
git pull
./scripts/link-skills.sh  # If any skills changed
```

## Troubleshooting

### Skill not found
```bash
# Re-link skills
cd ~/.claude/plugins/ClaudeSkills-Neronain
./scripts/link-skills.sh

# Restart Claude Code
```

### rtk hook not working
```bash
# Verify rtk is installed
which rtk
rtk --version

# Verify jq is installed
which jq
```

### Plugin not loading
```bash
# Verify settings.json has correct paths
cat ~/.claude/settings.json

# Check plugin directory exists
ls -la ~/.claude/plugins/ClaudeSkills-Neronain/
```

## License

MIT
