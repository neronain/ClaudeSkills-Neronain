---
name: cai
description: Launch and interact with CAI (Cybersecurity AI) — an AI-powered offensive/defensive security framework with 300+ model support. Use for CTF challenges, penetration testing workflows, reconnaissance, and vulnerability research.
allowed-tools: Bash
argument-hint: "[agent: ctf|recon|redteam|boot2root] [target: IP or URL] [task description]"
---

# CAI — Cybersecurity AI

CAI is an open-source AI-powered security framework by Alias Robotics.
- **300+ AI models** (Anthropic, OpenAI, DeepSeek, Ollama, etc.)
- **Specialized agents**: CTF, recon, red team, boot2root, flag discriminator
- **Human-in-the-loop** via Ctrl+C intervention

## Quick Launch

```bash
# Verify installation
pip show cai-framework

# Launch interactive shell (binary path on macOS with system Python 3.9)
/Users/tananan/Library/Python/3.9/bin/cai

# Or add to PATH permanently:
# echo 'export PATH="$HOME/Library/Python/3.9/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
# Then just: cai

# Disable license check if needed
CAI_LICENSE_OFF=1 /Users/tananan/Library/Python/3.9/bin/cai
```

## Agent Selection

Once inside `cai`, use `/agent` to list and switch agents:
| Agent | Purpose |
|-------|---------|
| `ctf_agent` | CTF challenge solving |
| `redteam_agent` | Offensive security testing |
| `reconnaissance` | OSINT & network scanning |
| `boot2root` | Full exploitation chains |
| `flag_discriminator` | CTF flag validation |

Switch with: `/agent [number]`

## Common Workflows

### CTF Challenge
```
cai> Solve this web vulnerability challenge at <URL>
```

### Network Reconnaissance
```
cai> Target IP: 192.168.x.x, perform a full network scan
```

### Model / Cost Management
```
/model      # Switch LLM provider or model
/cost       # View token usage and spending
/mcp        # Manage MCP integrations
/load logs/session.jsonl   # Resume prior session
```

## Environment Setup

Create `.env` in working directory:
```env
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...        # optional
CAI_LICENSE_OFF=1            # skip license for open usage
CAI_TRACING=true             # enable OpenTelemetry tracing
```

## Install / Update

```bash
pip install cai-framework
pip install --upgrade cai-framework
```

Source: https://github.com/aliasrobotics/cai
