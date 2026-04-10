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

Critical bugs are auto-moved from Backlog to To Do so a developer can pick them up immediately.

### Using /client-report

1. Run `/client-report PINK`
2. Claude asks for your name and which week
3. Claude pulls data from Jira and GitHub
4. Generates an HTML report with: completed, in progress, blockers, next week
5. Review the report, adjust anything inaccurate
6. Send to co-owner who forwards to client

## Backlog grooming

Grooming happens at two altitudes:

1. **Task-level (continuous, daily).** Throughout the day, you move Tasks and Bugs from Backlog to To Do as they meet the Definition of Ready. Developers pull from To Do whenever they have capacity -- your job is to keep To Do stocked with well-formed Tasks and Bugs.
2. **Epic-level (periodic, once per Epic).** When the team is about to finish the current Epic and pick up the next one, you break the next Epic down into Tasks. This is 20-30 minutes of focused work per Epic. See [New Project Setup → Ongoing](new-project-setup.md#ongoing-breaking-down-each-new-epic) for the breakdown procedure.

**Sign that it is time to break down the next Epic:** the current active Epic has fewer than 2 Tasks left in To Do, or developers are asking "what's next?" in Telegram. Err on the early side -- an empty To Do column is a bottleneck.

The rest of this section is about Task-level grooming.

### Definition of Ready

A ticket moves from Backlog to To Do when every box is checked. The full checklist lives in [Ticket Templates](ticket-templates.md#definition-of-ready) -- in short:

- Type set (Task or Bug)
- Title in action format
- What / Why has context
- Acceptance criteria: 3-7 testable items
- Priority set
- Figma link (if UI)
- Steps to reproduce + environment (if Bug)
- Assignee set at the moment you move it to To Do

If any box is unchecked, the ticket stays in Backlog.

### How to groom

1. **Filter Backlog** by priority, then by age. Top priority + newest first.
2. **For each ticket, walk the Definition of Ready checklist.** If something is missing, either fix it yourself (if you have enough context) or use `/create-feature` / `/create-bug` to rewrite the ticket interactively.
3. **If the ticket is genuinely not needed anymore, delete it.** A bloated Backlog is noise.
4. **Move ready tickets to To Do.** Set an assignee at the same time.
5. **Size check:** if a ticket has 7+ acceptance criteria or touches 5+ files, it's too big. Split it into multiple Tasks before moving to To Do (see [sizing rule](ticket-templates.md#sizing-rule)).

### Red flags

| Red flag | Fix |
|----------|-----|
| "Improve the settings page" | What specifically? Which settings? What's wrong now? |
| No acceptance criteria | Add 3-7 testable criteria before moving to To Do |
| "Make it fast" | Define: "Page loads within 2 seconds on 4G" |
| 10+ acceptance criteria | Too big -- break into 2-3 tickets |
| No Figma link for UI work | Ask designer for design before moving to To Do |
| Type: Task for a defect | Change to Bug so `/improvs:start` runs investigation |

## Daily routine (15-20 min)

### Morning check

1. **Scan each project board** -- any ticket stuck in "In Progress" for 2+ days?
2. **Check unassigned tickets in To Do and In Progress** -- everything in active columns must have an owner
3. **Read project Telegram chats** -- blockers? Help requests?
4. **Check open PRs** -- any waiting for review longer than 24 hours? Ping the reviewer
5. **Check Backlog size** -- is To Do getting thin? Groom more tickets from Backlog.

Or just run `/health-check <PROJECT>` -- it audits all of the above automatically and prints a report.

### JQL quick checks

```
# Stuck tickets
status = "In Progress" AND updated <= -2d

# PRs waiting for review
status = "In Review" AND updated <= -1d

# Unassigned in active columns
status in ("To Do", "In Progress") AND assignee is EMPTY

# Stale Backlog items that should probably be deleted
status = Backlog AND updated <= -30d
```

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
| Ticket cycle time | In Progress to Done | <3 days |
| PR review time | PR opened to reviewed | <24 hours |
| Stale tickets | `updated <= -7d` | 0 |
| To Do inventory | Count of tickets in To Do | 5-15 per active project (enough to pull without starving, not so many it goes stale) |

## Related

- [New Project Setup](new-project-setup.md) -- kickoff playbook when a new project lands
- [Ticket Templates](ticket-templates.md) -- how to write Tasks and Bugs that work with the Improvs flow
- [Skills Reference](../ai-playbook/skills.md) -- all skills including PM skills
- [Jira Workflow](jira-workflow.md) -- ticket statuses and board setup
- [Team Workflow](team-workflow.md) -- continuous Kanban flow, no sprints
- [Definition of Done](definition-of-done.md) -- when a ticket is truly done
