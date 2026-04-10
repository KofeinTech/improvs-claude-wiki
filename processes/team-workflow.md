# Team Workflow

How work flows through Improvs projects. Continuous, AI-first, minimal ceremony.

## Cadence

There are no sprints, no standups, no sync meetings. The board is the source of truth for what's happening, and Telegram is the channel for blockers and questions.

| Activity | Frequency | Who |
|---|---|---|
| Continuous grooming (Backlog → To Do) | Daily 15-20 min | PM (per project) |
| Board + Telegram monitoring | Daily | PM |
| Weekly client report | End of every week | PM (via `/client-report`) |

That's it. No other recurring meetings.

## How work moves

Improvs uses three issue types: **Epic** (planning container), **Task** (single unit of work), **Bug** (defect). See [Ticket Templates](ticket-templates.md) for the full model and when to use each.

Tasks and Bugs flow through 5 columns on the Kanban board:

```
Backlog → To Do → In Progress → In Review → Done
```

| Column | What it means |
|---|---|
| **Backlog** | Raw Tasks and Bugs. Not groomed. PM hasn't verified Definition of Ready. |
| **To Do** | Groomed and ready. Any developer can pull `/improvs:start <KEY>` and begin. |
| **In Progress** | Branch created (`/improvs:start` auto-moved the ticket here). |
| **In Review** | PR open (`/improvs:finish` auto-moved it). |
| **Done** | PR merged (auto). |

A Task or Bug only moves from Backlog to To Do when it meets every box in the [Definition of Ready](ticket-templates.md#definition-of-ready). If anything is missing, the ticket stays in Backlog.

**Epics don't flow through these columns** -- they're planning containers, not work items. An Epic stays as a container and collects its child Tasks. When all child Tasks are Done and no more are planned, mark the Epic as Done too.

## Status transitions are automatic

You almost never need to drag tickets manually:

1. **PM creates ticket** → goes into Backlog
2. **PM grooms** → moves to To Do when Definition of Ready is met
3. **Dev runs `/improvs:start <KEY>`** → branch is created → ticket auto-moves to In Progress
4. **Dev runs `/improvs:finish`** → PR is created → ticket auto-moves to In Review
5. **PR merges** → ticket auto-moves to Done

If any auto-transition fails, the link between branch name / PR title and the Jira key is broken. Check that the Jira key is in the branch name.

## Pulling work

Developers pull from To Do whenever they have capacity. **There are no WIP limits.** If you can hold multiple independent tickets in your head, that's fine -- AI handles context-switching better than humans, and the traditional "one ticket at a time" rule is less load-bearing in an AI-first workflow.

The only constraint: tickets you have In Progress must not depend on each other. If two tickets have a dependency, finish the first before starting the second.

## Communication

| Topic | Where it goes |
|---|---|
| **Blockers** | Telegram immediately -- don't wait for anything. There is no daily standup. |
| **Decisions** | Jira ticket comments. If a decision matters in 3 months, it must be in Jira, not in chat. |
| **Architecture or process** | Wiki PR, not Telegram. |
| **Quick questions** | Telegram. |

The PM's [daily routine](pm-guide.md) covers continuous board monitoring and intervention when something is stuck.

## Client communication

The `/client-report <PROJECT>` skill generates a weekly progress report from Jira + GitHub data. The PM runs it at the end of each week, reviews for accuracy, and sends to the co-owner who forwards to the client. No additional client-facing ceremony.

## Related

- [Jira Workflow](jira-workflow.md) -- board structure, branch naming, statuses, JQL filters
- [Ticket Templates](ticket-templates.md) -- how to write tickets that work with the Improvs flow
- [PM Guide](pm-guide.md) -- daily routine for the PM
- [Definition of Done](definition-of-done.md) -- when a ticket is complete
