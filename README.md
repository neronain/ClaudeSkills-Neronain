# ClaudeSkills-Neronain

My custom skills and configuration for Claude Code

## Installation

### Method 1: Manual Setup (Recommended)

1. Clone or download this repository to your Claude Code plugins directory:

```bash
cd ~/.claude/plugins
git clone https://github.com/neronain/ClaudeSkills-Neronain.git
```

2. Enable the skills in your `settings.json`:

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

3. Restart Claude Code

### Method 2: Using Marketplace (if available)

Add this marketplace in settings:

```json
{
  "extraKnownMarketplaces": {
    "neronain/ClaudeSkills-Neronain": {
      "source": {
        "source": "github",
        "repo": "neronain/ClaudeSkills-Neronain"
      },
      "installLocation": "~/.claude/plugins/ClaudeSkills-Neronain"
    }
  }
}
```

## Available Skills

### Ruflo Skills (7 skills)

| Skill | Description |
|-------|-------------|
| `init-project` | Initialize a new Ruflo project with MCP tools and configuration |
| `ruflo-doctor` | Run health checks and fix common issues |
| `swarm-init` | Initialize a multi-agent swarm with anti-drift configuration |
| `autopilot-loop` | Run autonomous /loop iterations for task completion |
| `autopilot-predict` | Predict optimal next actions using learned patterns |
| `intelligence-route` | Route tasks to optimal agents using neural patterns |
| `neural-train` | Train SONA neural patterns from successful completions |
| `security-scan` | Full security scans on codebase |
| `dependency-check` | Scan dependencies for CVEs and vulnerabilities |
| `tdd-workflow` | TDD London School workflow (mock-first, outside-in) |
| `test-gaps` | Detect missing test coverage and generate suggestions |
| `doc-gen` | Generate and maintain documentation with drift detection |
| `api-docs` | Generate API documentation from source code |
| `monitor-stream` | Stream live swarm events for real-time observability |
| `discover-plugins` | Discover and recommend ruflo plugins |

### feiskyer claude-code-settings Skills (14 skills)

- `autonomous-skill` - Multi-session task execution
- `codex-skill` - Code generation and analysis
- `command-creator` - Create custom commands
- `deep-research` - Comprehensive research tasks
- `eureka` - Idea generation and discovery
- `github-fix-issue` - Fix GitHub issues
- `github-review-pr` - Review GitHub pull requests
- `gpt-image-skill` - Image generation
- `kiro-skill` - Kiro assistant functionality
- `nanobanana-skill` - Nanobanana assistant
- `reflection` - Self-reflection and improvement
- `skill-creator` - Create new skills
- `spec-kit-skill` - Specification and testing kit
- `translate` - Translation assistance
- `youtube-transcribe-skill` - YouTube video transcription

## Usage

### Command Reference

```bash
# Initialize a new project
/claude-flow init --wizard

# Run health checks
/claude-flow doctor --fix

# Start a swarm
/claude-flow swarm init --topology hierarchical

# Autonomous task execution
/loop 5m /claude-flow autopilot

# Security scanning
/claude-flow security scan --depth full

# TDD workflow
/tdd-workflow src/components/Button.tsx

# Generate documentation
/doc-gen --target src/
```

### When to Use Each Plugin

| Task | Recommended Plugin |
|------|-------------------|
| Build a new feature | `ruflo-core` + `ruflo-swarm` + `ruflo-testgen` |
| Fix a bug | `ruflo-core` + `ruflo-jujutsu` |
| Audit security | `ruflo-security-audit` + `ruflo-aidefence` |
| Background tasks | `ruflo-loop-workers` + `ruflo-autopilot` |
| Multi-session work | `ruflo-goals` or `autonomous-skill` |
| API docs | `ruflo-docs` or `api-docs` |
| Search code patterns | `ruflo-agentdb` |

## Requirements

- Node.js 20+
- npm 9+
- Git
- Claude Code CLI (Claude 4.5+)

## Troubleshooting

If you encounter issues:

1. Run `ruflo doctor --fix` to diagnose and auto-repair
2. Check Node.js version: `node --version` (should be 20+)
3. Check npm version: `npm --version` (should be 9+)
4. Verify git is installed: `git --version`

## License

MIT
