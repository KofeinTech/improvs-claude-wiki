# Jira Workflow

How we use Jira at Improvs. This applies to everyone.

## Instance

One unified Jira Cloud instance at **improvs.atlassian.net**. All projects live here.

## Projects

| Key | Project | Board | Team |
|-----|---------|-------|------|
| FANT | Fantabase | Kanban | Egor |
| PINK | Pink | Kanban | Bogdan G., Volodymyr, Aleksey S., Taras |
| CUE | CueContact | Kanban | Maksim, Kolya, Artem |
| REW | Rewhip | Kanban | Dmitry, Taras |
| TRAD | TradingSim | Kanban | Andrey |
| SOL | Soltopiah | Kanban | Kyrilo, Vladyslav, Aleksey Z. |
| IMP | Improvs Internal | Kanban | Everyone |

All projects use Kanban (continuous flow, no sprints). See [Team Workflow](team-workflow.md) for how work moves through the board.

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

Improvs uses three issue types:

- **Epic** -- a multi-day-to-week planning container that groups related work. Not worked on directly. Created by the PM during project kickoff (see [New Project Setup](new-project-setup.md)).
- **Task** -- a single unit of work, one `/improvs:start` → `/improvs:finish` cycle. Features, refactor, infra. Usually linked to an Epic, can be standalone.
- **Bug** -- a defect. Usually standalone, can be linked to an Epic if scope-relevant.

There are no Stories or Subtasks. See [Ticket Templates](ticket-templates.md) for the full format, required fields, Definition of Ready, and filled examples. PMs should use `/create-feature <PROJECT>` and `/create-bug <PROJECT>` to create Tasks and Bugs interactively -- Claude walks through the required fields and enforces quality. Epics are lightweight enough to create directly in Jira without a dedicated skill.

### For internal requests (IMP project)

Use labels to trigger automation:
- `hiring-request` -- auto-assigns to HR, notifies CEO
- `access-request` -- standard access auto-approved, admin requires CEO
- `change-request` -- requires tech lead + CEO approval
- `offboarding` -- auto-creates subtasks for access revocation

Internal request templates (hiring, access, change) are managed by leads.

## Branch naming

Every branch must include the Jira key:

```
PINK-42-add-user-auth
CUE-108-fix-chat-scroll
```

A Claude Code hook validates this when you create the branch (`git checkout -b` or `git switch -c`). If your branch name doesn't contain a Jira key, the branch creation is blocked.

## Board

Each project board has five columns:
- **Backlog** -- raw tickets, not groomed yet
- **To Do** -- groomed tickets that meet the Definition of Ready, ready to pull
- **In Progress** -- someone is working on it (branch exists)
- **In Review** -- PR is open, waiting for review
- **Done** -- merged and deployed

### Board hygiene

- Don't leave tickets in "In Progress" if you're not actively working on them
- If a ticket is blocked, add a comment explaining why and flag it with a `blocked` label
- If a ticket is blocked indefinitely, move it back to Backlog with a comment explaining why

## GitHub for Jira integration

The GitHub for Jira app links development activity to Jira tickets automatically. It also drives the automatic status transitions described above (branch created, PR opened, PR merged).

### What it shows

Each ticket gets a "Development" panel showing:
- Branches created with that ticket key
- Commits containing the ticket key
- PRs opened, reviewed, and merged
- Build/deploy status

### Setup (admin only)

This is a one-time setup done by the org admin:

1. Install the [GitHub for Jira](https://marketplace.atlassian.com/apps/1219592/github-for-jira) app from the Atlassian Marketplace (free)
2. In Jira: go to **Settings** > **Apps** > **GitHub** > **Connect GitHub organization**
3. Authorize with the GitHub org (`KofeinTech`)
4. Select which repositories to sync (usually all project repos)

Developers do not need to do anything -- the integration works automatically once the admin has set it up.

### For developers

The integration works when your branch name contains the Jira key in uppercase:
- `PINK-42-add-user-auth` -- links to PINK-42
- `CUE-108-fix-chat-scroll` -- links to CUE-108

Commits and PR titles with the key also get linked. The Claude Code branch naming hook already enforces this format.

### Troubleshooting

- **Ticket shows no development activity:** check that your branch name includes the key in uppercase (e.g., `PINK-42`, not `pink-42`). Wait 1-5 minutes for the sync.
- **Status not auto-transitioning:** verify the integration is connected in Jira Settings > Apps > GitHub. If the app shows disconnected, ask your manager to re-authorize.
- **Commits not linking:** include the ticket key somewhere in the commit message or branch name.

## Filters and dashboards

**Useful JQL filters:**

```
# My open tickets
assignee = currentUser() AND status != Done

# Unassigned tickets in active columns
status in ("To Do", "In Progress") AND assignee is EMPTY

# Bugs created this week
type = Bug AND created >= startOfWeek()

# Stale tickets (no update in 7 days)
updated <= -7d AND status != Done

# Stale Backlog items (candidates for deletion)
status = Backlog AND updated <= -30d
```

PM (Darya) maintains project dashboards. Ask her if you need a custom view.
