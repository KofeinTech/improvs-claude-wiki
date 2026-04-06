# /onboard -- Project Briefing

Get a full briefing when joining a new project. Reads Jira project info, analyzes the codebase, and shows current sprint state.

## Usage

```
/onboard <JIRA_PROJECT_KEY>
```

Example: `/onboard PINK`

## Who uses this

Developers or PMs working on a project for the first time.

## What happens when you run it

1. **Asks your role** -- developer or PM (changes what it emphasizes)
2. **Reads project info from Jira** -- client, contacts, deadlines, team, repos
3. **Reads project wiki** -- architecture decisions, setup guides, API contracts
4. **Analyzes the codebase** (for developers) -- tech stack, directory structure, key patterns, commands
5. **Shows current sprint state** -- active tickets, who's working on what, blockers
6. **Saves ONBOARDING.md** -- reference file for future use

## Developer vs PM briefing

| Topic | Developer | PM |
|-------|-----------|-----|
| Architecture | Detailed | Overview |
| Code patterns | Yes | No |
| Sprint state | What's in progress | Full sprint with deadlines |
| Client info | Brief | Detailed |
| Team | Who works on what | Full team + contacts |

## Related

- [/start](../workflow/start.md) -- after onboarding, start your first task
