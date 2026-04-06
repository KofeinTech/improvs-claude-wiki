# /client-report -- Weekly Client Report

Generate a branded weekly progress report for a client project from Jira and GitHub data.

## Usage

```
/client-report <JIRA_PROJECT_KEY> [week]
```

Examples:
- `/client-report PINK` -- current week
- `/client-report PINK last` -- last week
- `/client-report PINK 2026-03-31` -- specific week

## Who uses this

PMs preparing the weekly update for a client.

## What happens when you run it

1. **Reads Jira data** for the project and time period:
   - Tickets completed (moved to Done)
   - Tickets in progress with estimates
   - Blockers and stale tickets (>3 days no update)
   - Time logged per ticket
   - Upcoming sprint items
2. **Reads GitHub data**:
   - PRs merged (count and summary)
   - Key changes (features added, bugs fixed)
3. **Generates a branded HTML report**:
   - Improvs.com branding (logo, colors, fonts)
   - Sections: Completed, In Progress, Blockers, Next Week, Summary
   - Total hours and sprint progress percentage
4. **Outputs the HTML file** for you to review, adjust, and send

## Report sections

| Section | What's in it |
|---------|-------------|
| Header | Project name, date range, prepared by |
| Completed This Week | Each done ticket with hours spent |
| In Progress | Active tickets with progress and ETA |
| Blockers | Anything blocking progress, who needs to act |
| Next Week Plan | Planned tickets with hour estimates |
| Summary | Total hours, sprint progress, health status (On Track / At Risk / Blocked) |

## Important rules

- Language is professional and client-friendly. No internal jargon.
- Hours are rounded to nearest 0.5h.
- If no blockers, it says "No blockers this week" (section is never omitted).
- **PM must review before sending** -- never send auto-generated reports directly to clients.

## Related

- [/create-feature](create-feature.md) -- create tickets that show up in next week's report
- [/create-bug](create-bug.md) -- create bug tickets tracked in the report
