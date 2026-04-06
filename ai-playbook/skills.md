# Skills Reference

Skills are slash commands in Claude Code that automate common workflows. Type `/skill-name` in Claude Code to run them.

Skills are deployed to your Claude Code automatically via the Improvs organization. If a skill is missing, contact your manager.

## Available Skills

### Workflow Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/start](skills/start.md) | Begin a Jira task -- read ticket, Figma, create branch, evaluate complexity | Starting any new task |
| [/finish](skills/finish.md) | Complete a task -- review, push, create PR, update Jira, log time | Done coding, ready for PR |
| [/bug](skills/bug.md) | Investigate and fix a bug from Jira | You're assigned a bug ticket |
| [/hotfix](skills/hotfix.md) | Emergency fix for production | Something is broken in prod right now |
| [/quickfix](skills/quickfix.md) | Lightweight start for trivial tasks | Typo fix, config change, one-liner |
| [/review](skills/review.md) | Review a PR against rules and acceptance criteria | Before approving someone's PR |
| [/onboard](skills/onboard.md) | Project briefing for new team members | First time on a project |
| [/test](skills/test.md) | Independent test generation from acceptance criteria | Before /finish, to verify coverage |

### PM / Management Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/create-feature](skills/create-feature.md) | Create a structured Jira feature ticket | You have a new feature idea |
| [/create-bug](skills/create-bug.md) | Create a structured Jira bug report | A bug was found and needs a ticket |

### Development Tools

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/docker-init](skills/docker-init.md) | Generate Dockerfile + docker-compose for a project | Setting up Docker for a project |
| [/docs](skills/docs.md) | Generate or update project documentation | README, API docs, architecture docs needed |
| [/figma-check](skills/figma-check.md) | Verify UI implementation matches Figma design | After building a screen, before PR |

### Reporting Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/client-report](skills/client-report.md) | Generate weekly progress report for a client | End of week, before sending update |

### Subagents

Subagents are AI assistants that run as background helpers. They're invoked by skills, not directly by you.

| Subagent | Model | Used by |
|----------|-------|---------|
| [PM agent](skills/subagent-pm.md) | Sonnet | Answers project status questions from live Jira data |
| [Test agent](skills/subagent-test.md) | Sonnet | Independent QA -- writes tests from AC, finds edge cases |

## How to use skills

1. Open Claude Code in your project directory
2. Type the skill command with its arguments:
   ```
   /start PINK-42
   /bug PINK-55
   /review 47
   /create-feature PINK
   /finish
   ```
3. Claude will guide you through the flow step by step
4. Follow the prompts -- Claude will ask questions if anything is unclear

## Common flows

| Scenario | Flow |
|----------|------|
| New feature | `/start PINK-42` -> code -> `/finish` |
| Trivial fix (typo, config) | `/quickfix PINK-50` -> fix -> `/finish` |
| Bug fix | `/bug PINK-55` -> fix -> `/finish` |
| Emergency in prod | `/hotfix PINK-99` (all-in-one, no separate /finish needed) |
| Review a colleague's PR | `/review 47` |
| PM creates work | `/create-feature PINK` or `/create-bug PINK` |
| New dev joins project | `/onboard PINK` |
| Weekly client update | `/client-report PINK` |
| Verify UI matches design | `/figma-check` (with Figma node URL) |

## Tips

- Skills respect all loaded rules (flutter-rules, security-rules, etc.) automatically
- Quality hooks still fire during skill execution -- tests must pass, code must be formatted
- `/start` classifies tasks as trivial/simple/complex and adjusts the workflow accordingly
- After `/bug` or `/start`, always finish with `/finish` to create the PR and log time
- `/hotfix` has its own built-in finish step -- no separate `/finish` needed
