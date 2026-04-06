# /quickfix -- Lightweight Start for Trivial Tasks

Skip the ceremony of /start when the task is obviously trivial. No Figma, no complexity evaluation, no planning.

## Usage

```
/quickfix <JIRA_TICKET_KEY>
```

Example: `/quickfix PINK-50`

## Who uses this

Developers fixing something trivial -- typo, config value, color change, text update.

## What happens when you run it

1. **Reads the Jira ticket** -- validates it's actually trivial
2. **Validates it's trivial** -- if 3+ AC, multiple layers, or words like "refactor" / "migrate", stops and redirects to `/start`
3. **Creates branch automatically** -- auto-generates name from ticket title, no questions asked
4. **Moves Jira to In Progress** -- adds comment with start time and "Complexity: trivial"
5. **Says "Ready"** -- you make the change, commit, run /finish

## When to use /quickfix vs /start

| Task | Use |
|------|-----|
| Fix a typo in the UI | `/quickfix` |
| Change a color or spacing value | `/quickfix` |
| Update a config value | `/quickfix` |
| Add a field to a form | `/start` |
| New screen or feature | `/start` |
| Anything touching multiple files | `/start` |

## Important rules

- Claude validates the ticket is actually trivial. If it's not, you get redirected to `/start`
- No TDD required for trivial tasks
- Branch name is auto-generated -- speed is the point
- Still need to run `/finish` when done

## Related

- [/start](start.md) -- for non-trivial tasks
- [/finish](finish.md) -- complete the task after fixing
