# /improvs:onboard -- Project Briefing

Get a full briefing when joining a new project. Reads Jira project info, analyzes the codebase, and shows current work in flight (active Epics + In Progress tickets).

## Usage

```
/improvs:onboard <JIRA_PROJECT_KEY>
```

Example: `/improvs:onboard PINK`

## Who uses this

Developers or PMs working on a project for the first time.

## What happens when you run it

1. **Asks your role** -- developer or PM (changes what it emphasizes)
2. **Reads project info from Jira** -- client, contacts, deadlines, team, repos
3. **Reads project wiki** -- architecture decisions, setup guides, API contracts
4. **Analyzes the codebase** (for developers) -- tech stack, directory structure, key patterns, commands
5. **Shows current work in flight** -- active Epics (with Tasks done / total counts), In Progress tickets by assignee, blockers
6. **Saves ONBOARDING.md** -- reference file for future use

## Developer vs PM briefing

| Topic | Developer | PM |
|-------|-----------|-----|
| Architecture | Detailed | Overview |
| Code patterns | Yes | No |
| Active work | What's in progress | Active Epics + In Progress list, plus deadlines |
| Client info | Brief | Detailed |
| Team | Who works on what | Full team + contacts |

## Related

- [/improvs:start](../workflow/start.md) -- after onboarding, start your first task
