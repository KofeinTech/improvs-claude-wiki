# /hotfix -- Emergency Fix

Emergency fix for production issues. Branches from main, fast fix, creates PRs to both main and develop. Speed is the priority.

## Usage

```
/hotfix <JIRA_TICKET_KEY>
```

Example: `/hotfix PINK-99`

If there is no Jira ticket yet, run `/hotfix` without arguments -- Claude will create one.

## Who uses this

Developers fixing something that is broken in production right now.

## When to use /hotfix vs /bug

| Situation | Use |
|-----------|-----|
| Production is broken, users are affected | `/hotfix` |
| Bug exists but not urgent, in backlog | `/bug` |

## What happens when you run it

1. **Reads the Jira ticket** (or creates one if no ticket exists)
2. **Branches from main** -- `hotfix/PINK-99-description` (never from develop)
3. **Moves ticket to In Progress** + adds "hotfix" label
4. **Fast investigation** -- finds root cause, shows a 2-line plan
5. **Fixes the bug** -- absolute minimum change, still writes a test
6. **Creates two PRs**:
   - PR to **main** -- the urgent fix, labeled `hotfix` + `urgent`
   - PR to **develop** -- sync PR so develop doesn't diverge
7. **Updates Jira** -- moves to In Review, adds PR links, logs time
8. **Shows summary** with PR numbers and next steps

## What makes hotfix different

| | /bug | /hotfix |
|---|------|---------|
| Branch from | develop | **main** |
| Planning | Short investigation plan | 2-line plan -- just fix + test |
| PRs created | None (use /finish) | **Two: main + develop** |
| Jira update | Manual via /finish | **Automatic, built-in** |
| Time logging | Via /finish | **Automatic, built-in** |

## Safety guardrails

- Claude still writes a test, even in emergencies. A hotfix without a test will break again.
- All hooks still run -- code must pass analyze + test checks. No shortcuts.
- If the fix is larger than ~50 lines, Claude will ask: "This is bigger than a typical hotfix. Continue or switch to /bug?"
- No refactoring, no dependency updates, no "while I'm here" changes.

## After the hotfix

Get the main PR reviewed and merged ASAP. The develop sync PR can be merged after.

## Related

- [/bug](bug.md) -- for non-urgent bugs
- [/review](../quality/review.md) -- to review the hotfix PR
