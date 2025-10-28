---
name: jira-read-ticket
description: Read a Jira ticket using the `acli` command line tool. The user must provide, at a minimum, the ticket key. Use this when the user asks to read or view a Jira ticket or card.
allowed-tools: [Bash(acli:*)]
---

# Read Jira Ticket Skill

This skill helps read Jira tickets using the Atlassian CLI (`acli`) tool.

## Required Information

### Minimum Required
- **Key**: The key or id of the ticket (required)

## Basic Command Structure

```bash
acli jira workitem view [key] --fields '*navigable'
```

## Output Handling

The acli command will output the ticket information. Parse this to:
- Extract the ticket key (e.g., "PROJ-456") and display the key and summary to the user
- Print each field on a new line.
  - Summary
  - Type
  - Status
  - Assignee
  - Description
  - Comments if any

## Error Handling

Common errors:
- **Command not found: acli**: User needs to install `acli` using these instructions:
```
brew tap atlassian/homebrew-acli
brew install acli
acli jira auth login --web
```

- **Authentication required**: User needs to run `acli jira auth login --web`

