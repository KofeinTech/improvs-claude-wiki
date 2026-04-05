# System Maintenance Rules

This system only works if it stays current. These are the rules for keeping everything alive.

## Ownership

| Owner | What they maintain |
|-------|-------------------|
| **PM (Darya)** | processes/, Jira boards, sprint reports |
| **HR (Alina)** | onboarding/offboarding execution |
| **Developers** | engineering/ standards, ai-playbook/ content, project CLAUDE.md files |
| **CEO** | Private repo (skills, hooks, settings), monthly + quarterly reviews, wiki overall |

## Weekly review (PM, 15 min)

- Jira: orphan tickets? stale sprints?
- Team changes: anyone joined/left? Notify HR
- GitHub: PRs open > 3 days? Abandoned branches?

## Monthly review (CEO, 1 hour)

- Wiki: any outdated pages?
- Skills: which are used, which are dead?
- Hooks: still working?
- Claude usage: who's active, who needs help?
- Budget: actual vs planned
- Security: any access to revoke?

## Quarterly review (full team, 1-2 hours)

- Process retrospective: what works, what doesn't
- Update developer rules
- Archive obsolete project pages
- Refresh CLAUDE.md templates
- Review shared skills catalog

## Enforcement

1. Onboarding/offboarding tickets include access provisioning/revocation subtasks
2. New skill = documented in same PR
3. Process changes require wiki PR approved by CEO
4. Monthly CEO review is a recurring Jira ticket (auto-created 1st of each month)
5. Quarterly retrospective is a calendar event with agenda sent 2 days before

## If rules are not followed

- First time: CEO reminds the owner
- Second time: discussed in quarterly retro
- Pattern: the system is wrong, not the person -- simplify or automate
