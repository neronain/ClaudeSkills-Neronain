# ClaudeSkills-Neronain

All-in-one Claude Code setup with **Skills** and **Tools** for LMS Development.

## What's Included

This repository contains everything you need to set up Claude Code:

| Type | Name | Description |
|------|------|-------------|
| **Skills** | 9arm Skills | Engineering & productivity skills (debug, review, docs) |
| **Skills** | Ruflo Skills | Advanced multi-agent workflows (swarm, autopilot) |
| **Skills** | feiskyer Skills | Additional utilities (autonomous, codex, github) |
| **Tools** | RTK | Token-optimized CLI (60-90% savings) |

## Repository Structure

```
ClaudeSkills-Neronain/
├── skills/           # Agent skills
│   ├── engineering/  # Debug, review, docs
│   ├── productivity/ # Management, communication
│   ├── misc/         # Rarely used skills
│   └── ...
├── tools/            # CLI tools
│   └── rtk/          # Token optimizer
│       ├── hooks/    # Pre-tool hooks
│       └── docs/     # Tool documentation
├── hooks/            # Global hooks
│   └── rtk-rewrite.sh
└── scripts/          # Utility scripts
    ├── link-skills.sh
    └── list-skills.sh
```

## Installation (New Machine)

### Step 1: Install Dependencies

```bash
brew install rtk jq
```

### Step 2: Clone This Repository

```bash
cd ~/.claude/plugins
git clone https://github.com/neronain/ClaudeSkills-Neronain.git
```

### Step 3: Install Skills (Symlink)

```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
./scripts/link-skills.sh
```

### Step 4: Enable Plugins in `~/.claude/settings.json`

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

### Step 5: Restart Claude Code

## Available Skills

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

## Available Tools

### RTK - Rust Token Killer

**60-90% token savings** on LLM operations

**Key Commands:**
- `rtk git status` - Filtered git status (~90% savings)
- `rtk pnpm list` - Compact dependency tree (~70% savings)
- `rtk cargo test` - Failures only (~90% savings)

**Auto-Rewrite:**
- `git status` → `rtk git status` (transparent)
- `npm list` → `rtk pnpm list` (transparent)

## Quick Start Commands

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
