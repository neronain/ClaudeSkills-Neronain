# Composio Setup Guide

Composio CLI สำหรับเชื่อมต่อ SaaS 500+ apps

## Installation

```bash
npm install -g composio
```

## Quick Start

### 1. Login to Composio

```bash
composio login
```

หรือถ้าไม่มี browser:
```bash
composio login --no-browser
```

### 2. Connect an App

```bash
# List available apps
composio apps

# Add a connection
composio add <app-name>
```

### 3. List Connections

```bash
composio connections
```

## Available Integrations

| App | Purpose |
|-----|---------|
| `slack` | Send messages, read channels |
| `gmail` | Send/receive emails |
| `github` | Issues, PRs, repos |
| `notion` | Read/write pages, databases |
| `jira` | Create issues, update tickets |
| `asana` | Task management |
| `trello` | Board management |
| `linear` | Issue management |
| `google-calendar` | Calendar events |
| `google-drive` | File storage |
| `google-sheets` | Spreadsheet |
| `hubspot` | CRM |
| `salesforce` | Enterprise CRM |
| `stripe` | Payments |
| `shopify` | E-commerce |

## Usage with Claude Code

After connecting apps, use in Claude Code:

```bash
connect slack send-message --channel "#general" --text "Hello!"
connect github create-issue --repo "owner/repo" --title "Bug"
connect gmail send-email --to "user@example.com" --subject "Subject"
```

## Notes

- First-gen apps may show deprecation warnings
- Use v2 apps when available (e.g., `slack-v2`)
