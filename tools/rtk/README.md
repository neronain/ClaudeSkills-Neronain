# RTK Tools

RTK (Rust Token Killer) is a CLI tool that reduces LLM token consumption by 60-90% by filtering and compressing command outputs.

## Structure

- [hooks/](hooks/) - Pre-tool hooks for Claude Code
- [docs/](docs/) - Documentation and references

## Installation

### Prerequisites
- Node.js 20+
- npm 9+
- Homebrew (recommended)

### Quick Install

```bash
brew install rtk
```

### Verify Installation

```bash
rtk --version   # Should show rtk version
rtk gain        # Should show token savings stats
```

## Usage

RTK automatically rewrites commands via the PreToolUse hook. Example:

```bash
git status    # Automatically becomes: rtk git status
npm list      # Automatically becomes: rtk pnpm list
cargo test    # Automatically becomes: rtk cargo test
```

## Commands

| Category | Commands |
|----------|----------|
| Git | `rtk git status`, `rtk git diff`, `rtk git log`, `rtk git add`, `rtk git commit`, `rtk git push` |
| Files | `rtk ls`, `rtk read`, `rtk grep`, `rtk find` |
| Tests | `rtk cargo test`, `rtk vitest`, `rtk jest`, `rtk pytest` |
| Pnpm | `rtk pnpm list`, `rtk pnpm install`, `rtk pnpm outdated` |

## Token Savings (Typical Session)

| Operation | Standard | RTK | Savings |
|-----------|----------|-----|---------|
| `git status` | ~2,000 tokens | ~200 | -90% |
| `npm list` | ~8,000 tokens | ~2,400 | -70% |
| `cargo test` | ~25,000 tokens | ~2,500 | -90% |
| **Total** | ~150,000 | ~45,000 | **-70%** |

## Supported AI Tools

RTK supports Claude Code, GitHub Copilot, Cursor, Gemini CLI, and 10+ more.

See [rtk-ai/rtk](https://github.com/rtk-ai/rtk) for full compatibility list.

## Configuration

Config file: `~/.config/rtk/config.toml`

```toml
[hooks]
exclude_commands = ["curl", "playwright"]

[tee]
enabled = true
mode = "failures"
```

## Troubleshooting

### rtk command not found

```bash
# Check PATH
which rtk

# Reinstall
brew install rtk
```

### Hook not working

```bash
# Verify rtk is installed
rtk --version

# Check hook
cat ~/.claude/hooks/rtk-rewrite.sh
```

## License

Apache 2.0 - see [LICENSE](LICENSE) for details.

## Credits

- Original: [rtk-ai/rtk](https://github.com/rtk-ai/rtk)
- Author: Patrick Szymkowiak, Florian Bruniaux, Adrien Eppling
