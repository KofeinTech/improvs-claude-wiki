# Jira Workflow

How we use Jira at Improvs. This applies to everyone.

## Instance

One unified Jira Cloud instance at **improvs.atlassian.net**. All projects live here.

## Projects

| Key | Project | Board | Team |
|-----|---------|-------|------|
| FANT | Fantabase | Scrum | Egor |
| PINK | Pink | Scrum | Bogdan G., Volodymyr, Aleksey S., Taras |
| CUE | CueContact | Scrum | Maksim, Kolya, Artem |
| REW | Rewhip | Scrum | Dmitry, Taras |
| TRAD | TradingSim | Scrum | Andrey |
| SOL | Soltopiah | Scrum | Kyrilo, Vladyslav, Aleksey Z. |
| IMP | Improvs Internal | Kanban | Everyone |

**IMP** is for internal tasks: HR requests, hiring, tooling, infrastructure, process improvements.

## Ticket lifecycle

```
Backlog  -->  To Do  -->  In Progress  -->  In Review  -->  Done
                            (auto)          (auto)        (auto)
```

Status changes happen automatically via GitHub integration:
- **Branch created** with ticket key (e.g., `PINK-42-...`) --> moves to "In Progress"
- **PR opened** with ticket key --> moves to "In Review"
- **PR merged** --> moves to "Done"
- **PR closed without merge** --> moves back to "In Progress"

You rarely need to drag tickets manually.

## Creating tickets

### For project work

Every piece of work needs a ticket before you start. No ticket = no branch = no work.

**Feature/story:**
- Title in user story format when possible: "As a user, I want X so that Y"
- Add acceptance criteria (checklist of what "done" looks like)
- Add Figma link if there are UI changes
- Set priority and estimate

**Bug:**
- Title: clear description of what's broken
- Steps to reproduce
- Expected vs actual behavior
- Screenshots or screen recording
- Device/OS info

### For internal requests (IMP project)

Use labels to trigger automation:
- `hiring-request` -- auto-assigns to HR, notifies CEO
- `access-request` -- standard access auto-approved, admin requires CEO
- `change-request` -- requires tech lead + CEO approval
- `offboarding` -- auto-creates subtasks for access revocation

See [Jira Templates](https://github.com/KofeinTech/improvs-claude-private/blob/main/automation/jira-templates/all-templates.md) for the full template formats.

## Branch naming

Every branch must include the Jira key:

```
PINK-42-add-user-auth
CUE-108-fix-chat-scroll
```

A Claude Code hook validates this when you create the branch (`git checkout -b` or `git switch -c`). If your branch name doesn't contain a Jira key, the branch creation is blocked.

## Sprint board

Each project board shows the current sprint:
- **To Do** -- tickets planned for this sprint, not started
- **In Progress** -- someone is working on it (branch exists)
- **In Review** -- PR is open, waiting for review
- **Done** -- merged and deployed

### Board hygiene

- Don't leave tickets in "In Progress" if you're not actively working on them
- If a ticket is blocked, add a comment explaining why and flag it
- If a ticket won't be finished this sprint, move it to the next sprint during planning

## Linking tickets to code

GitHub for Jira integration shows development activity on each ticket:
- Branches created
- Commits made
- PRs opened, reviewed, merged
- Build status

All of this appears automatically in the ticket's "Development" panel when you use the correct ticket key in your branch name.

## Filters and dashboards

**Useful JQL filters:**

```
# My open tickets
assignee = currentUser() AND status != Done

# Tickets without assignee in current sprint
sprint in openSprints() AND assignee is EMPTY

# Bugs created this week
type = Bug AND created >= startOfWeek()

# Stale tickets (no update in 7 days)
updated <= -7d AND status != Done
```

PM (Darya) maintains project dashboards. Ask her if you need a custom view.
