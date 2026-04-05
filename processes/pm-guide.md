# PM Guide

Darya's playbook for managing projects at Improvs. Also useful for anyone stepping in as backup.

## Role summary

The PM coordinates delivery across all active projects. You are the bridge between what clients need (via co-owners) and what developers build. Your job is visibility, not micromanagement.

## Daily routine (15-20 min)

### Morning check

1. **Scan each project board** -- are any tickets stuck in "In Progress" for more than 2 days?
2. **Check for unassigned tickets** -- every ticket in the current sprint must have an owner
3. **Read project Telegram chats** -- any blockers reported? Any help requests?
4. **Check open PRs** -- any PR waiting for review longer than 24 hours? Ping the reviewer

### Quick JQL checks

```
# Stuck tickets (in progress 2+ days, no commit activity)
status = "In Progress" AND updated <= -2d

# PRs waiting for review
status = "In Review" AND updated <= -1d

# Unassigned in current sprint
sprint in openSprints() AND assignee is EMPTY AND status != Done
```

If you see something stuck, don't wait -- ask the developer in Telegram what's blocking them.

## Weekly responsibilities

### Weekly sync per project (15-30 min each)

Run this with each project team:
1. What shipped this week?
2. What's blocked?
3. Any scope changes or client feedback?
4. Is the sprint goal on track?

Document action items in Jira ticket comments, not Telegram.

### Weekly review (15 min, solo)

From [Maintenance Rules](maintenance-rules.md):
- [ ] Any orphan tickets without assignee or sprint?
- [ ] Any stale sprints that should be closed?
- [ ] Anyone joined or left this week? Notify HR to update contacts
- [ ] Any PRs open for more than 3 days? Any abandoned branches?
- [ ] Flag blockers to CEO if anything is stuck

## Sprint responsibilities

### Sprint planning (Monday of week 1)

For each project:
1. Review backlog with the team -- are tickets groomed?
2. Each ticket needs: title, description, acceptance criteria, estimate, Figma link (if UI)
3. Pull tickets into the sprint based on priority and team capacity
4. Set a sprint goal: one sentence summarizing what this sprint delivers
5. Verify every ticket has an assignee

### Sprint review (Friday of week 2)

1. What was completed vs planned? Calculate completion rate
2. Demo anything visible (optional but valuable for morale)
3. What slipped and why? Document in sprint retrospective
4. Move incomplete tickets to next sprint or back to backlog

## Client reporting

Co-owners handle direct client communication. Your role:

1. **Prepare data** -- ensure Jira tickets are up to date so reports are accurate
2. **Run `/client-report`** skill when co-owner requests a weekly update
3. **Review the generated report** (2 min) -- check for accuracy, adjust if needed
4. **Send to co-owner** who forwards to client

Report structure: completed this week, in progress, blockers, next week plan, hours summary.

## Ticket quality checklist

Before a ticket enters a sprint, verify:

- [ ] Clear title (what needs to happen, not vague)
- [ ] Description with context (why this matters)
- [ ] Acceptance criteria (specific, testable conditions)
- [ ] Figma link (if UI changes are involved)
- [ ] Priority set
- [ ] Estimate set (story points or hours)
- [ ] Assignee set
- [ ] No duplicate tickets for the same work

Bad: "Fix the app" -- no criteria, no context
Good: "Fix crash on profile edit when user clears the name field" + steps to reproduce + expected behavior

## Escalation

When to involve CEO:
- A project is at risk of missing a client deadline
- A developer is blocked for more than 1 day with no resolution
- Scope change from client that affects timeline or budget
- Team conflict or performance issue
- Any security incident

## Tools you use daily

| Tool | What for |
|------|----------|
| Jira | Boards, tickets, sprint management, time reports |
| Telegram | Quick communication with devs and co-owners |
| Claude (Standard) | Draft specs, generate reports, analyze velocity |
| GitHub | Check PR status, review activity |

## Metrics to track

| Metric | How to check | Target |
|--------|-------------|--------|
| Sprint completion rate | Completed vs planned tickets | >80% |
| Ticket cycle time | Time from "In Progress" to "Done" | <3 days for tasks |
| PR review time | Time from PR opened to reviewed | <24 hours |
| Stale tickets | JQL: updated <= -7d | 0 |
| Unassigned tickets in sprint | JQL filter | 0 |
