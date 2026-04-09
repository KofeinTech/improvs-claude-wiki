# PM Guide

Playbook for managing projects at Improvs. For the PM (Darya) and anyone stepping in as backup.

## Getting started with Claude Code (for PMs)

PMs use Claude Code Standard plan. You don't write code -- you use it to create tickets, generate reports, and get project context.

### Setup

Run the [setup script](../setup-developer.sh) or follow the [manual setup](../ai-playbook/claude-code-setup.md). You need the same Jira and GitHub MCP connections as developers.

### Your skills

Type `/` in Claude Code to see all available skills. The ones you'll use most:

| Skill | What it does | How to run |
|-------|-------------|-----------|
| `/create-feature PINK` | Walk you through creating a structured feature ticket | Describe the feature, Claude asks questions, creates in Jira |
| `/create-bug PINK` | Walk you through creating a structured bug report | Describe the bug, Claude ensures repro steps + severity |
| `/client-report PINK` | Generate a branded weekly report from Jira + GitHub data | Run at end of week, review before sending |
| `/improvs:onboard PINK` | Get a full briefing on a project (PM mode) | First time managing a project |

### Using /create-feature

1. Run `/create-feature PINK` (replace PINK with the project key)
2. Claude asks: "Describe the feature you need"
3. You describe it in plain language
4. Claude asks 2-4 clarifying questions (scope, platform, design needs)
5. Claude generates a structured ticket with acceptance criteria
6. You review, adjust, and confirm
7. Ticket is created in Jira

Claude enforces quality: every ticket gets testable AC, an "Out of Scope" section, and a clear title. If the feature is too big, Claude suggests breaking it down.

### Using /create-bug

1. Run `/create-bug PINK`
2. Claude asks: "Describe the bug"
3. You describe what's broken
4. Claude asks for missing details (repro steps, platform, frequency)
5. Claude generates a structured bug ticket with severity
6. You review and confirm
7. Ticket is created in Jira with appropriate priority

Critical bugs are auto-added to the current sprint.

### Using /client-report

1. Run `/client-report PINK`
2. Claude asks for your name and which week
3. Claude pulls data from Jira and GitHub
4. Generates an HTML report with: completed, in progress, blockers, next week
5. Review the report, adjust anything inaccurate
6. Send to co-owner who forwards to client

## Backlog grooming

Run grooming before each sprint planning. Goal: every ticket that enters a sprint is ready to work on.

### What "ready" means

A ticket is ready for a sprint when it has:
- Clear title (action, not vague)
- Description with context (why this matters)
- Acceptance criteria (3-7 testable items)
- Figma link (if UI changes)
- Priority set
- No duplicates

### How to groom

1. **Filter the backlog** -- sort by priority, then by age
2. **For each ticket, ask:**
   - Is this still needed? (delete if not)
   - Is the description clear enough for a developer who hasn't seen it before?
   - Are the acceptance criteria specific and testable?
   - Is there a Figma design if it involves UI?
   - Can this be done in 1-4 hours? (if not, break it down)
3. **Use /create-feature or /create-bug** to rewrite poorly written tickets
4. **Mark groomed tickets** by adding them to the "Ready" column or adding a label

### Red flags in tickets

| Red flag | Fix |
|----------|-----|
| "Improve the settings page" | What specifically? Which settings? What's wrong now? |
| No acceptance criteria | Add 3-7 testable criteria before sprint |
| "Make it fast" | Define: "Page loads within 2 seconds on 4G" |
| 10+ acceptance criteria | Too big -- break into 2-3 tickets |
| No Figma link for UI work | Ask designer for design before sprint |

## Sprint planning

### Before planning (preparation)

1. Groom the backlog (see above)
2. Check team availability -- anyone on vacation, sick, or split across projects?
3. Know the sprint goal from the co-owner or client priority

### During planning (30-60 min per project)

1. **State the sprint goal** -- one sentence: "This sprint we ship push notifications"
2. **Walk through groomed tickets** by priority
3. **Assign each ticket** to a developer
4. **Check capacity** -- don't overload. Rule of thumb: 6-7 productive hours per day, 60-70% of sprint capacity for planned work (rest is bugs, meetings, reviews)
5. **Confirm with the team** -- does everyone understand their tickets?

### After planning

- Every ticket in the sprint has: assignee, AC, priority, estimate
- Sprint goal is documented in Jira sprint description
- Team knows what "done" looks like for this sprint

## Daily routine (15-20 min)

### Morning check

1. **Scan each project board** -- any ticket stuck in "In Progress" for 2+ days?
2. **Check unassigned tickets** -- every sprint ticket must have an owner
3. **Read project Telegram chats** -- blockers? Help requests?
4. **Check open PRs** -- any waiting for review longer than 24 hours? Ping the reviewer

### JQL quick checks

```
# Stuck tickets
status = "In Progress" AND updated <= -2d

# PRs waiting for review
status = "In Review" AND updated <= -1d

# Unassigned in sprint
sprint in openSprints() AND assignee is EMPTY AND status != Done
```

## Weekly responsibilities

### Weekly sync per project (15-30 min each)

1. What shipped this week?
2. What's blocked?
3. Scope changes or client feedback?
4. Is the sprint goal on track?

Document action items in Jira ticket comments, not Telegram.

### Sprint review (end of sprint)

1. What was completed vs planned? Calculate completion rate
2. Demo anything visible (optional but good for morale)
3. What slipped and why?
4. Move incomplete tickets to next sprint or back to backlog

## Client reporting

Co-owners handle direct client communication. Your role:

1. Ensure Jira tickets are up to date so reports are accurate
2. Run `/client-report PINK` when co-owner requests a weekly update
3. Review the generated report (2 min) -- check for accuracy
4. Send to co-owner who forwards to client

## Escalation

Involve CEO when:
- Project at risk of missing a client deadline
- Developer blocked for more than 1 day with no resolution
- Scope change that affects timeline or budget
- Team conflict or performance issue
- Security incident

## Metrics

| Metric | How to check | Target |
|--------|-------------|--------|
| Sprint completion rate | Completed vs planned | >80% |
| Ticket cycle time | In Progress to Done | <3 days |
| PR review time | PR opened to reviewed | <24 hours |
| Stale tickets | `updated <= -7d` | 0 |

## Related

- [Skills Reference](../ai-playbook/skills.md) -- all skills including PM skills
- [Jira Workflow](jira-workflow.md) -- ticket statuses and board setup
- [Sprint Workflow](sprint-workflow.md) -- 2-week sprint cadence
- [Definition of Done](definition-of-done.md) -- when a ticket is truly done
