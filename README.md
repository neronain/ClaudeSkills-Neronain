# ClaudeSkills-Neronain

All-in-one Claude Code setup with **Skills** and **Tools** .

## What's Included

This repository contains everything you need to set up Claude Code:

| Type | Name | Description |
|------|------|-------------|
| **Skills** | 9arm Skills | Engineering & productivity skills (debug, review, docs) |
| **Skills** | Ruflo Skills | Advanced multi-agent workflows (swarm, autopilot) |
| **Skills** | feiskyer Skills | Additional utilities (autonomous, codex, github) |
| **Skills** | Official Plugins | Code review, automation, CLAUDE.md management |
| **Skills** | Connect (Composio) | 500+ SaaS integrations (Gmail, Slack, GitHub, Notion, Jira) |
| **Skills** | Playwright | Browser automation for web testing |
| **Agents** | Security Auditor | Security vulnerability scanning, OWASP, compliance |
| **Tools** | RTK | Token-optimized CLI (60-90% savings) |

## New Skills (Composio + Playwright)

| Skill | Description | Use Case |
|-------|-------------|----------|
| `/connect` | 500+ SaaS integrations | Gmail, Slack, GitHub, Notion, Jira, Asana, Trello, Linear, HubSpot, Salesforce, Stripe, and more |
| `/playwright` | Browser automation | Web testing, scraping, screenshot capture, form automation |

## New Agents

| Agent | Description | Use Case |
|-------|-------------|----------|
| `/security-auditor` | Security vulnerability scanning | OWASP Top 10 checks, dependency audit, secret detection, compliance (GDPR, PCI-DSS) |

## Repository Structure

```
ClaudeSkills-Neronain/
├── skills/           # Agent skills
│   ├── engineering/  # Debug, review, docs
│   ├── productivity/ # Management, communication
│   ├── misc/         # Rarely used skills
│   └── ...
├── tools/            # CLI tools
│   ├── rtk/          # Token optimizer
│   └── mcp/          # MCP server configurations (GitHub, Postgres, Search, etc.)
├── hooks/            # Global hooks
│   └── rtk-rewrite.sh
├── configs/          # Configuration examples
│   ├── settings-snippet.json   # Complete settings.json reference
│   ├── hooks-reference.md      # Hook documentation
│   └── rtk-hook-guide.md       # RTK hook setup guide
├── scripts/          # Utility scripts
│   ├── link-skills.sh
│   └── update-from-github.sh
├── agents/           # 17 specialized AI agents
└── skills/           # Agent skills
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

### Official Plugins (New!)

#### PR Review Toolkit (6 agents) - Automated Code Review

| Skill | Description |
|-------|-------------|
| `/code-reviewer` | General code review for project guidelines |
| `/code-simplifier` | Code simplification and refactoring |
| `/comment-analyzer` | Code comment accuracy and maintainability |
| `/pr-test-analyzer` | Test coverage quality and completeness |
| `/silent-failure-hunter` | Error handling and silent failures |
| `/type-design-analyzer` | Type design quality and invariants |

#### CLAUDE.md Management

| Skill | Description |
|-------|-------------|
| `/claude-md-improver` | Audit and improve CLAUDE.md files |
| `/revise-claude-md` | Capture session learnings into CLAUDE.md |

#### Hookify - Automation Rules

| Skill | Description |
|-------|-------------|
| `/hookify` | Create hooks from conversation patterns |
| `/hookify:configure` | Configure rules interactively |
| `/hookify:list` | List all active rules |
| `/hookify:help` | Get hookify help |

#### Feature Development

| Skill | Description |
|-------|-------------|
| `/feature-dev` | 7-phase feature development workflow |

#### Code Review

| Skill | Description |
|-------|-------------|
| `/code-review` | Automated PR review with multiple agents |

#### Claude Code Setup

| Skill | Description |
|-------|-------------|
| `/claude-automation-recommender` | Recommend automations (hooks, subagents, skills) |

## MCP Tools

| Tool | Description | Setup |
|------|-------------|-------|
| **github** | GitHub issues, PRs, repos, code search | Add GitHub token |
| **postgres** | PostgreSQL queries, schema info | Add DATABASE_URL |
| **exa** | Web search with Exa AI | Add EXA_API_KEY |
| **perplexity** | AI-powered search | Add PERPLEXITY_API_KEY |
| **notion** | Read/write Notion pages, databases | Add NOTION_API_KEY |
| **slack** | Send messages, read channels | Add SLACK_BOT_TOKEN |
| **google-maps** | Location search, directions | Add GOOGLE_API_KEY |
| **google-search** | Web search with Google | Add API keys |

See `tools/mcp/` for configurations.

## Hooks

| Hook | Description | Location |
|------|-------------|----------|
| **RTK Rewrite** | Auto-wraps bash with RTK for 80% token savings | `hooks/rtk-rewrite.sh` |

See `configs/` for hook documentation.

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
/post-mortem

# Automated PR Review (Official Plugin)
/code-review
/code-reviewer
/code-simplifier

# Feature Development (Official Plugin)
/feature-dev

# CLAUDE.md Management (Official Plugin)
/claude-md-improver
/revise-claude-md

# Hookify - Create Automation Rules (Official Plugin)
/hookify

# Leadership Updates
/management-talk

# TDD
/tdd-workflow

# Documentation Gen
/doc-gen

# Connect (Composio SaaS)
/connect slack send-message --channel "#general" --text "Hello!"
/connect github create-issue --repo "owner/repo" --title "Bug"
/connect jira create-issue --project "PROJ" --summary "..."
/connect gmail send-email --to "user@example.com" --subject "Subject"

# Playwright (Browser Automation)
/playwright open https://example.com
/playwright click "text=Get Started"
/playwright fill "#email" "test@example.com"
/playwright screenshot /tmp/page.png

# Security Auditor
/security-auditor code ./src/api
/security-auditor deps package.json
/security-auditor secrets ./
/security-auditor compliance gdpr

# 17 Specialized Agents (New!)
@fullstack-developer Create a REST API for user management
@typescript-pro Implement a generic repository pattern
@python-pro Build async HTTP client
@rust-engineer Create ownership patterns
@nextjs-developer Set up App Router with Server Components
@frontend-developer Build accessible React component
@backend-developer Design database schema
@api-designer Create OpenAPI specification
@devops-engineer Set up CI/CD pipeline
@kubernetes-specialist Create deployment manifest
@database-administrator Optimize PostgreSQL queries
@llm-architect Build RAG pipeline
@security-auditor Perform code security audit
@penetration-tester Test web application security
@architect-reviewer Review system design
@project-manager Plan sprint backlog
@productivity-specialist Design workflow automation

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

## Updating Skills from GitHub

To update skills from the official GitHub repositories:

```bash
cd ~/.claude/plugins/ClaudeSkills-Neronain
./scripts/update-from-github.sh
```

This will clone/update repositories:
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates)
- [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
- [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit)
- [anthropics/claude-code](https://github.com/anthropics/claude-code)
- [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)
- [FlorianBruniaux/claude-code-ultimate-guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide)
- [affaan-m/ECC](https://github.com/affaan-m/ECC)
- [shareAI-lab/learn-claude-code](https://github.com/shareAI-lab/learn-claude-code)

## License

MIT
