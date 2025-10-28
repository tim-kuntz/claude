---
name: jira-create-ticket
description: Create a Jira ticket using the acli command line tool. The user must provide, at a minimum, the ticket summary. Use this when the user asks to create a Jira ticket or card.
allowed-tools: [Bash(acli:*), Read(~/.claude/skills/create-jira-ticket/defaults.conf)]
---

# Create Jira Ticket Skill

This skill helps create Jira tickets using the Atlassian CLI (`acli`) tool.

## Defaults Configuration

The skill uses default values from `~/.claude/skills/create-jira-ticket/defaults.conf`.

**IMPORTANT**: Always read this file at the start of ticket creation to get current defaults:
```bash
Read(~/.claude/skills/create-jira-ticket/defaults.conf)
```

**Example defaults.conf:**
```bash
# Jira Ticket Defaults
project=MYPROJ
status=Ready
type=Task
assignee=user@example.com
labels=example,demo
```

The examples below use these sample values. Read the actual file to get the real values.

User-provided values always override defaults from the config file.

## Required Information

### Minimum Required
- **Summary**: Brief description of the ticket (required)

### Commonly Used Optional Fields
- **Project**: Project key (e.g., "TEAM", "PROJ")
- **Type**: Work item type (e.g., "Task", "Bug", "Story", "Epic")
- **Description**: Detailed description of the work
- **Assignee**: Email address, account ID, or '@me' for self-assign
- **Labels**: Comma-separated list of labels
- **Parent**: Parent work item ID (for subtasks)

## Basic Command Structure

```bash
acli jira workitem create \
  --summary "Summary text" \
  --project "PROJECT_KEY" \
  --type "Task"
```

## Steps to Create a Ticket

1. **Read defaults**
   Read the defaults file to get current values:
   ```bash
   Read(~/.claude/skills/create-jira-ticket/defaults.conf)
   ```
   Extract the values (project, type, status, assignee, labels) and use them directly in commands.

2. **Gather required information**
   - Ask user for summary if not provided
   - Use default project or ask if user wants to override
   - Use default type or ask if user wants to override

3. **Gather optional information**
   - Description (short or long form)
   - Assignee (use default or user-specified)
   - Labels (use default or user-specified)
   - Parent ticket (if creating a subtask)

4. **Choose creation method**
   - Simple: Use command line flags for all fields
   - Description from file: Use `--description-file` for long descriptions
   - Editor: Use `--editor` flag for interactive editing
   - JSON: Use `--from-json` for complex ticket structures

5. **Execute the command**
   - Run the acli command with appropriate flags
   - Capture the ticket key/ID from output

6. **Transition status (if configured)**
   - If `status` is set in defaults.conf, transition the ticket:
   ```bash
   acli jira workitem transition --key "$TICKET_KEY" --status "$status" --yes
   ```

7. **Provide confirmation**
   - Show the created ticket key
   - Show the final status (if transitioned)
   - **REQUIRED**: Construct and display the ticket URL:
     ```bash
     # Get the Jira site from auth status (strings filters binary chars)
     SITE=$(acli jira auth status 2>&1 | strings | grep "Site:" | awk '{print $2}')
     # Display the URL
     echo "View ticket at: https://${SITE}/browse/${TICKET_KEY}"
     ```
   - The ticket URL MUST be shown to the user in every ticket creation

## Common Patterns

### Simple Task
```bash
acli jira workitem create \
  --summary "Add user authentication" \
  --project "TEAM" \
  --type "Task"
```

### Bug with Description
```bash
acli jira workitem create \
  --summary "Fix login redirect loop" \
  --project "PROJ" \
  --type "Bug" \
  --description "Users get stuck in redirect loop after password reset" \
  --label "bug,authentication"
```

### Task with Assignee
```bash
acli jira workitem create \
  --summary "Review API documentation" \
  --project "TEAM" \
  --type "Task" \
  --assignee "@me"
```

### Story with Description File
For longer descriptions, create a temporary file:
```bash
cat > /tmp/jira-desc.txt <<'EOF'
As a user, I want to be able to filter search results by date
so that I can find recent items more easily.

Acceptance Criteria:
- Date range picker is available on search page
- Results are filtered when date range is selected
- Date range persists across page navigation
EOF

acli jira workitem create \
  --summary "Add date filter to search" \
  --project "TEAM" \
  --type "Story" \
  --description-file "/tmp/jira-desc.txt"

rm /tmp/jira-desc.txt
```

### Interactive Editor Mode
```bash
acli jira workitem create \
  --project "TEAM" \
  --type "Task" \
  --editor
```
This opens a text editor where the user can write the summary and description.

### Using Defaults Configuration
```bash
# Read defaults file first to get: project=MYPROJ, type=Task, status=Ready, assignee=user@example.com
# Then use those values directly in commands

# Create ticket using defaults
TICKET=$(acli jira workitem create \
  --summary "Update API documentation" \
  --project "MYPROJ" \
  --type "Task" \
  --assignee "user@example.com" \
  --json | jq -r '.key')

# Transition to configured status
acli jira workitem transition \
  --key "$TICKET" \
  --status "Ready" \
  --yes

echo "Created $TICKET and moved to Ready"

# Get site and display URL (strings filters binary chars)
SITE=$(acli jira auth status 2>&1 | strings | grep "Site:" | awk '{print $2}')
echo "View ticket at: https://${SITE}/browse/${TICKET}"
```

### Override Defaults
```bash
# Read defaults file first to get: project=MYPROJ, type=Task
# Then override type to Bug while using other defaults

acli jira workitem create \
  --summary "Fix memory leak in processor" \
  --project "MYPROJ" \
  --type "Bug" \
  --assignee "user@example.com"
```

## Decision Tree

1. **Read defaults**
   - Always read `~/.claude/skills/create-jira-ticket/defaults.conf` first to get current values
   - Parse the file to extract project, type, status, assignee, labels values

2. **Is project key needed?**
   - Check defaults.conf first → Use default if set
   - User explicitly provided → Use user's value (overrides default)
   - No default and not provided → Ask user for project key

3. **What type of ticket?**
   - User explicitly provided → Use user's value (overrides default)
   - No override → Use default from defaults.conf (Task)
   - Bug fix mentioned → Suggest type="Bug"
   - New feature mentioned → Suggest type="Story" or "Epic"

4. **How long is the description?**
   - None → Skip description
   - Short (1-2 lines) → Use `--description`
   - Long (multiple paragraphs) → Use `--description-file`
   - Complex formatting → Consider `--editor` or JSON

5. **Who should be assigned?**
   - Check defaults.conf for default assignee
   - User explicitly provided → Use user's value (overrides default)
   - User themselves → `--assignee "@me"`
   - Specific person → `--assignee "email@example.com"`
   - Default assignee → `--assignee "default"`
   - Unassigned → Skip assignee flag

6. **Should status be transitioned?**
   - Check defaults.conf for status value
   - User explicitly provided → Use user's value (overrides default)
   - If status is set → Transition after ticket creation
   - If empty → Skip transition (keep initial status)

## Advanced Usage

### Create with Parent (Subtask)
```bash
acli jira workitem create \
  --summary "Write unit tests" \
  --project "TEAM" \
  --type "Task" \
  --parent "TEAM-123"
```

### Multiple Labels
```bash
acli jira workitem create \
  --summary "Update dependencies" \
  --project "TEAM" \
  --type "Task" \
  --label "maintenance,security,urgent"
```

## Output Handling

The acli command will output the created ticket information. Parse this to:
- Extract the ticket key (e.g., "TEAM-456")
- Show confirmation to user
- Provide link to view ticket (construct from ticket key if possible)

## Error Handling

Common errors:
- **Command not found: acli**: Install acli with `brew install acli`, then authenticate with `acli auth login --web`
- **Project not found**: User needs to provide valid project key
- **Invalid type**: Use one of: Task, Bug, Story, Epic, Subtask
- **Authentication required**: User needs to run `acli auth login --web`
- **Required field missing**: Some projects require additional fields

## Notes

- **Defaults Configuration**: Always read `~/.claude/skills/create-jira-ticket/defaults.conf` at the start
- **User Values Override**: Any value explicitly provided by the user overrides the default
- **Summary**: Keep concise but descriptive
- **Description**: Include context, acceptance criteria, and any relevant details
- **Labels**: Use existing project labels when possible
- **Type**: Match the project's workflow (some projects have custom types)
- **Assignee**: Can be changed later if uncertain
- **Status Transition**: Status must be set after creation using the `transition` command
- **Config File Location**: `~/.claude/skills/create-jira-ticket/defaults.conf`
