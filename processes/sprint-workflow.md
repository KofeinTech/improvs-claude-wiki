# Sprint Workflow

How sprints work at Improvs. 2-week cycles.

## Sprint cadence

| Event | When | Duration | Who |
|-------|------|----------|-----|
| Sprint planning | Monday, week 1 | 30-60 min | PM + project team |
| Weekly sync | Every week | 15-30 min | Project team |
| Sprint review | Friday, week 2 | 15 min | PM + project team |

## Sprint planning

PM (Darya) runs planning for each project. At the start of each sprint:

1. Review backlog -- are tickets groomed with acceptance criteria?
2. Pick tickets for the sprint based on priority and team capacity
3. Assign tickets to developers
4. Set sprint goal: one sentence describing what this sprint delivers

Tickets must have:
- Clear title and description
- Acceptance criteria (what "done" looks like)
- Figma link (if UI changes)
- Estimate (story points or hours)

## Daily work

No daily standups. Developers work independently and communicate in project Telegram chats when needed.

**Instead of standups, we rely on:**
- Jira board shows what everyone is working on
- Branch creation auto-moves tickets to "In Progress"
- PR creation auto-moves tickets to "In Review"
- Merge auto-moves tickets to "Done"

If you're blocked, say so immediately in Telegram. Don't wait for a meeting.

## Weekly sync

Quick check-in per project:
- What shipped this week?
- What's blocked?
- Any scope changes or surprises?
- Is the sprint goal on track?

## Sprint review

End of every sprint:
- PM reviews what was completed vs planned
- Demo anything visible (new screens, features)
- Discuss what slipped and why
- Update project wiki page if anything significant shipped

## Between sprints

No gap between sprints. Sprint 2 starts the Monday after Sprint 1 ends. PM prepares the backlog for next sprint during the current sprint's second week.

## Jira automation

These happen automatically via GitHub-Jira integration:

| Trigger | Jira action |
|---------|-------------|
| Branch created with ticket key | Ticket moves to "In Progress" |
| PR opened with ticket key | Ticket moves to "In Review" |
| PR merged | Ticket moves to "Done" |
| PR closed without merge | Ticket moves back to "In Progress" |
