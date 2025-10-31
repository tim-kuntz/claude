---
name: jira
description: Work with Jira workitems (tickets, cards) using the acli command-line tool. Handles viewing, creating, updating, and transitioning Jira issues using configuration defaults from ~/.claude/skills/jira/config.json.
allowed-tools: ["Bash(acli:*)", "Read(~/.claude/skills/jira/*)"]
---

# Jira Skill

This skill enables interaction with Jira using the Atlassian CLI (`acli`) tool.

## Configuration

When using this skill, it is helpful to have a `config.json` file in the same directory (`~/.claude/skills/jira/config.json`) with your default values. The config file should contain:

- `project`: Default project key (e.g., "PROJ")
- `board`: Default board name or ID
- `assignee`: Default assignee username
- `issue_type`: Default issue type (e.g., "Story", "Bug", "Task")

## Usage Instructions

### Reading Configuration

ALWAYS read the config.json file first to get default values:
```bash
cat ~/.claude/skills/jira/config.json
```

Parse the JSON to extract default values and use them in subsequent acli commands.

### Common Operations

#### 1. View a Jira Issue
```bash
acli jira workitem view <ISSUE-KEY>
```

#### 2. List Issues
```bash
acli jira workitem search --jql "project = <PROJECT> AND assignee = <USERNAME> AND status = 'In Progress'"
```

#### 3. Create a New Issue
```bash
acli jira workitem create --project <PROJECT-KEY> --type <ISSUE-TYPE> --summary "<SUMMARY>" --description "<DESCRIPTION>" --assignee <ASSIGNEE>
```

#### 4. Update an Issue
```bash
acli jira workitem edit --key <ISSUE-KEY> --summary "<NEW-SUMMARY>" --description "<NEW-DESCRIPTION>"
```

#### 5. Add a Comment
```bash
acli jira workitem comment --key <ISSUE-KEY> --body "<COMMENT-TEXT>"
```

#### 6. Transition an Issue (Change Status)
```bash
acli jira workitem transition --key <ISSUE-KEY> --status "<STATUS>"
```

Common status: "To Be Groomed", "Ready To Pickup", "In Development", "Ready for CR", "In Code Review", "Done", "Blocked"

#### 7. Assign an Issue
```bash
acli jira workitem assign --key <ISSUE-KEY> --assignee <USERNAME>
```

#### 7. Unassign an Issue
```bash
acli jira workitem assign --key <ISSUE-KEY> --remove-assignee
```

## Best Practices

1. **Always read config first**: Load the config.json file at the start to get default values
2. **Use defaults smartly**: If the user doesn't specify a value, use the default from config
3. **Confirm before creating**: Summarize what will be created before running the create command
4. **Handle errors gracefully**: If acli returns an error, explain it to the user and suggest fixes
5. **Use JQL for complex queries**: For advanced filtering, use JQL (Jira Query Language)
6. **Format output clearly**: When displaying issue information, format it in a readable way

## Examples

**Example 1: User says "Show me my current issues"**
1. Read config.json to get default project and assignee
2. Run: `acli jira workitem search --jql "project = <project> AND assignee = @me AND status != Done"`
3. Format the results for the user

**Example 2: User says "Create a bug for login issue"**
1. Read config.json to get defaults (project, issue_type, assignee)
2. Confirm with user: "I'll create a Bug in project X assigned to Y with summary 'login issue'"
3. Run: `acli jira workitem create --project <project> --type Bug --summary "login issue" --assignee <assignee>`
4. Return the created issue key and a link to the ticket in the form "https://appfolio.atlassian.net/browse/<issue-key>"

**Example 3: User says "Move PROJ-123 to Done"**
1. Run: `acli jira workitem transition --key PROJ-123 --status "Done"`
2. Confirm completion

## Troubleshooting

- **Command not found: acli**: User needs to install `acli` using these instructions:
```
brew tap atlassian/homebrew-acli
brew install acli
acli jira auth login --web
```

- **Authentication required**: User needs to run `acli jira auth login --web`

- If `~/.claude/skills/jira/config.json` doesn't exist, create it from the template (config.template.json) and inform the user to update it.
