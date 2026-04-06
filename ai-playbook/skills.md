# Skills Reference

Skills are slash commands in Claude Code that automate common workflows. Type `/skill-name` in Claude Code to run them.

Skills are deployed to your Claude Code automatically via the Improvs organization. If a skill is missing, contact your manager.

## Available Skills

### Developer Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/bug](skills/bug.md) | Investigate and fix a bug from Jira | You're assigned a bug ticket |
| [/review](skills/review.md) | Review a PR against rules and acceptance criteria | Before approving someone's PR |
| [/hotfix](skills/hotfix.md) | Emergency fix for production | Something is broken in prod right now |

### PM / Management Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/create-feature](skills/create-feature.md) | Create a structured Jira feature ticket | You have a new feature idea or requirement |
| [/create-bug](skills/create-bug.md) | Create a structured Jira bug report | A bug was found and needs a ticket |

### Reporting Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/client-report](skills/client-report.md) | Generate weekly progress report for a client | End of week, before sending update to client |

## How to use skills

1. Open Claude Code in your project directory
2. Type the skill command with its arguments:
   ```
   /bug PINK-55
   /review 47
   /create-feature PINK
   ```
3. Claude will guide you through the flow step by step
4. Follow the prompts -- Claude will ask questions if anything is unclear

## How skills work with other tools

Skills use MCP servers to connect to external tools:

- **Jira MCP** -- reads/updates tickets, logs time
- **GitHub MCP** -- reads PRs, creates branches and PRs
- **Figma MCP** -- reads designs for UI verification

All MCP servers are set up during [developer onboarding](claude-code-setup.md).

## Common skill combinations

| Scenario | Flow |
|----------|------|
| New feature from scratch | `/start PINK-42` (plan + implement) then `/finish` (PR + Jira) |
| Bug fix | `/bug PINK-55` (investigate + fix) then `/finish` (PR + Jira) |
| Emergency in prod | `/hotfix PINK-99` (fix + PR to main + develop, all-in-one) |
| PM creates work | `/create-feature PINK` or `/create-bug PINK` |
| Review a colleague's PR | `/review 47` |
| Weekly client update | `/client-report PINK` |

## Tips

- Skills respect all loaded rules (flutter-rules, security-rules, etc.) automatically
- Quality hooks still fire during skill execution -- tests must pass, code must be formatted
- If a skill asks you a question, answer honestly. "I don't know" is better than guessing
- You can interrupt a skill at any time by pressing Ctrl+C
- After `/bug` or `/start`, always finish with `/finish` to create the PR and log time
