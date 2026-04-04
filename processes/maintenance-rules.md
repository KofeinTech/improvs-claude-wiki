# System Maintenance Rules

This system only works if it stays current. These are the rules for keeping everything alive.

## Ownership

| Owner | What they maintain |
|-------|-------------------|
| **PM (Darya)** | projects/ pages, processes/, Jira boards, sprint reports |
| **Product Manager (Aleksey S.)** | Jira roadmaps, feature specs, client requirements |
| **HR (Alina)** | company/contacts.md, company/org-chart.md, onboarding/offboarding |
| **Developers** | engineering/ standards, ai-playbook/ skills, project CLAUDE.md files |
| **CEO** | Private repo (skills, hooks, settings), monthly + quarterly reviews |

## Weekly review (PM, 15 min)

- Jira: orphan tickets? stale sprints?
- Contacts: anyone joined/left? Update contacts.md same day
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

1. Contacts must be current -- onboarding/offboarding tickets include "update contacts.md" subtask
2. Sprint cannot close without project page update
3. New skill = catalog entry in same PR
4. Process changes require wiki PR approved by CEO
5. Monthly CEO review is a recurring Jira ticket (auto-created 1st of each month)
6. Quarterly retrospective is a calendar event with agenda sent 2 days before

## If rules are not followed

- First time: CEO reminds the owner
- Second time: discussed in quarterly retro
- Pattern: the system is wrong, not the person -- simplify or automate
