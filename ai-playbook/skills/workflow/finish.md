# /improvs:finish -- Complete a Task

Push your code, create a PR, and update Jira status. Run this after you're done coding.

## Usage

```
/improvs:finish
```

No arguments -- works with the current branch.

## Who uses this

Every developer who has finished coding and is ready for review.

## What happens when you run it

1. **Validates state** -- checks branch has a Jira key, no uncommitted changes, commits exist
2. **Runs code review** (for simple/complex tasks) -- invokes /improvs:review, blocks if issues found
3. **Verifies tests exist** (for simple/complex tasks) -- checks for test files in the diff
4. **Pushes to remote** -- `git push -u origin <branch>`
5. **Creates PR** via GitHub MCP -- with Jira link, change summary, AC checklist, test status
6. **Updates Jira** -- moves ticket to "In Review", adds PR link

## What the PR body looks like

```
## Jira Ticket
[PINK-42](https://improvs.atlassian.net/browse/PINK-42)

## What Changed
- Added biometric authentication feature
- Settings toggle for enabling/disabling

## Acceptance Criteria
- [x] User can enable biometric login in settings
- [x] App prompts biometric on launch
- [x] Fallback to PIN if biometric fails

## Testing
- [x] Unit tests: 4 added
- [x] All tests passing
```

## Behavior by task type

| Type | Review | Test verification | PR target |
|------|--------|-------------------|-----------|
| Trivial | Skipped | Skipped | `develop` |
| Simple | Required | Required | `develop` |
| Complex | Required | Required | `develop` |
| Hotfix | Lightweight (correctness only) | Skipped | `main` + `develop` sync |

### Hotfix flow

When `/improvs:start` detects a production emergency (Critical/Blocker priority or `hotfix` label), it records `Hotfix: true` in the Jira comment. `/improvs:finish` reads this flag and:

1. Runs `/improvs:review` in **hotfix mode** -- focuses on correctness and safety, skips style nitpicks
2. Skips `/improvs:write-tests` verification entirely -- hotfixes ship fast
3. Creates **two PRs**: one targeting `main` (the urgent fix) and one targeting `develop` (sync back)
4. The `main` PR should be reviewed and merged ASAP. The `develop` sync PR is merged after

## Important rules

- Never commits code -- you must commit before running /improvs:finish
- Never force pushes
- Never creates PR to `main` unless it is a hotfix
- If any AC is not addressed, asks for confirmation before creating PR

## Related

- [/improvs:start](start.md) -- begin a task (run this first)
- [/improvs:review](../quality/review.md) -- standalone PR review
- [/improvs:write-tests](../quality/write-tests.md) -- generate tests independently
