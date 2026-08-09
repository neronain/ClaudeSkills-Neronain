---
name: connect
description: Connect Claude to 500+ SaaS apps (Gmail, Slack, GitHub, Notion, Jira, etc.)
---

# Connect Skill - SaaS Integration

Connect Claude to 500+ external applications via Composio.

## Available Integrations

### Communication
- **Slack** - Send messages, read channels, manage threads
- **Gmail** - Send/receive emails, search, manage drafts
- **Discord** - Send messages, manage channels
- **Telegram** - Bot messaging

### Project Management
- **Jira** - Create issues, update tickets, search issues
- **Asana** - Create tasks, update projects
- **Trello** - Manage cards, boards, lists
- **Linear** - Create issues, manage teams
- **ClickUp** - Task management
- **Notion** - Read/write pages, databases

### Development
- **GitHub** - Issues, PRs, repos, commits
- **GitLab** - Repos, issues, MRs
- **Bitbucket** - Repos, branches, PRs

### Email & CRM
- **Outlook** - Email, calendar
- **HubSpot** - CRM, contacts, deals
- **Salesforce** - Records, queries
- **Pipedrive** - Deals, leads

### File Storage
- **Google Drive** - Files, folders
- **Dropbox** - Files, folders
- **OneDrive** - Files, folders

### Calendar
- **Google Calendar** - Events, schedules
- **Calendly** - Scheduling

### E-commerce
- **Shopify** - Products, orders
- **Stripe** - Payments, customers

### Analytics
- **Google Analytics** - Reports, data
- **Mixpanel** - Events, funnels
- **Amplitude** - User analytics

## Usage

```
 connect <integration> <action>
```

## Examples

```bash
# Slack
connect slack send-message --channel "#general" --text "Hello!"

# GitHub
connect github create-issue --repo "owner/repo" --title "Bug fix" --body "Description"

# Jira
connect jira create-issue --project "PROJ" --summary "Issue summary"

# Gmail
connect gmail send-email --to "user@example.com" --subject "Subject" --body "Body"

# Notion
connect notion create-page --database "DB_ID" --title "New Page"
```

## Setup

1. Run `npx composio-cli login`
2. Connect your desired integrations
3. Enable in Claude Code settings

## Resources

- [Composio Docs](https://docs.composio.dev/)
- [All Integrations](https://composio.dev/tools)
