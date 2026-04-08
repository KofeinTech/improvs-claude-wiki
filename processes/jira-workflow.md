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

Template:
```
Title: As a [user], I want [action] so that [benefit]

Acceptance Criteria:
- [ ] ...
- [ ] ...
- [ ] ...

Figma Design: <paste Figma frame link, or "No UI changes">
Priority: Critical / High / Medium / Low
Estimate: <story points or hours>
Notes: <additional context, edge cases, dependencies>
```

**Bug:**
- Title: clear description of what's broken
- Steps to reproduce
- Expected vs actual behavior
- Screenshots or screen recording
- Device/OS info

Template:
```
Title: [Bug] <short description of the issue>

Steps to Reproduce:
1.
2.
3.

Expected Result: <what should happen>
Actual Result: <what happens instead>
Severity: Critical / High / Medium / Low

Device / OS:
- Device:
- OS version:
- App version:

Screenshots / Screen Recording: <attach>
Logs: <paste relevant error logs>
```

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

# Tickets without assignee in current sprint
sprint in openSprints() AND assignee is EMPTY

# Bugs created this week
type = Bug AND created >= startOfWeek()

# Stale tickets (no update in 7 days)
updated <= -7d AND status != Done
```

PM (Darya) maintains project dashboards. Ask her if you need a custom view.
