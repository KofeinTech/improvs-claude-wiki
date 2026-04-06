# /health-check -- Project Health Audit

Audit a project's Jira board and GitHub repos. Finds stuck tickets, stale PRs, unassigned work, inconsistencies, and blockers.

## Usage

```
/health-check <JIRA_PROJECT_KEY>
```

Example: `/health-check PINK`

## Who uses this

PMs (daily morning check) and leads (weekly review).

## What it checks

### Jira

- Tickets stuck in "In Progress" for 2+ days
- Tickets untouched for 7+ days
- Unassigned tickets in the current sprint
- Tickets missing acceptance criteria
- Blocked tickets
- Status inconsistencies (e.g., "In Review" with no PR, "Done" with no merged PR)

### GitHub

- PRs open for 3+ days with no review
- Abandoned branches (no commits in 7+ days, not merged)
- PRs without Jira ticket links
- PRs with merge conflicts

## What the output looks like

```
HEALTH CHECK: PINK
Date: 2026-04-06

--- CRITICAL (act today) ---
- [PINK-42] Stuck 5 days in "In Progress"
- PR #47 has merge conflicts, open 4 days

--- WARNINGS (act this week) ---
- [PINK-38] No acceptance criteria -- in current sprint
- 2 tickets unassigned in sprint

--- INFO ---
- Sprint completion: 6/10 tickets done (60%)
- No blockers found

SUMMARY: 2 critical, 2 warnings
```

Each issue includes a suggested action (ping reviewer, add AC, delete branch, etc.).

## Important notes

- This is read-only -- it never modifies tickets or PRs
- Run daily as your morning check, or weekly for a full review
- Pairs well with the JQL queries in the [PM Guide](../../processes/pm-guide.md)

## Related

- [/client-report](client-report.md) -- weekly report for clients (uses similar data)
- [/onboard](onboard.md) -- project briefing for new team members
