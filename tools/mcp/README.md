# MCP Tools Setup

Model Context Protocol (MCP) tools for integrating external services.

## What is MCP?

MCP (Model Context Protocol) is a standard for connecting AI models to external data sources and tools.

## Available MCP Tools

### GitHub MCP
- GitHub issues, PRs, repos, commits
- Search code, issues, pull requests
- Get file contents, list branches

### PostgreSQL MCP
- Execute SQL queries
- Get schema information
- Run migrations

### Search MCP
- Web search (Exa, Perplexity)
- Document search
- Knowledge base queries

### Playwright MCP
- Browser automation
- Web testing
- Screenshot capture

### Notion MCP
- Read/write Notion pages
- Database queries
- Page updates

### Slack MCP
- Send messages
- Read channels
- Manage threads

## Installation

### Using Claude Settings

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:pass@host:5432/db"]
    }
  }
}
```

### Using Claude Code UI

1. Open Claude Code settings
2. Go to MCP Servers
3. Click "Add Server"
4. Select or enter server configuration

## Configuration Examples

### GitHub with Auth
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxx",
        "GITHUB_BASE_URL": "https://api.github.com"
      }
    }
  }
}
```

### PostgreSQL
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost:5432/mydb?user=postgres"],
      "env": {
        "DATABASE_URL": "postgresql://localhost:5432/mydb?user=postgres"
      }
    }
  }
}
```

### Multiple Search Tools
```json
{
  "mcpServers": {
    "exa": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-exa"],
      "env": {
        "EXA_API_KEY": "your-exa-key"
      }
    },
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-perplexity"],
      "env": {
        "PERPLEXITY_API_KEY": "your-perplexity-key"
      }
    }
  }
}
```

## Usage in Claude Code

Once configured, MCP tools appear in your tools list:

- GitHub tools: `github_search_code`, `github_get_issues`, etc.
- PostgreSQL tools: `postgres_query`, `postgres_list_tables`, etc.
- Search tools: `search`, `search_advanced`, etc.

## Installation Commands

```bash
# Install MCP servers globally
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-exa
```

## Environment Variables

| Tool | Environment Variable |
|------|---------------------|
| GitHub | `GITHUB_PERSONAL_ACCESS_TOKEN` |
| PostgreSQL | `DATABASE_URL` |
| Exa | `EXA_API_KEY` |
| Perplexity | `PERPLEXITY_API_KEY` |
| Notion | `NOTION_API_KEY` |
| Slack | `SLACK_BOT_TOKEN` |
EOF
echo "MCP README created"