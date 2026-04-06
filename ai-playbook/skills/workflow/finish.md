# /finish -- Complete a Task

Push your code, create a PR, and update Jira status. Run this after you're done coding.

## Usage

```
/finish
```

No arguments -- works with the current branch.

## Who uses this

Every developer who has finished coding and is ready for review.

## What happens when you run it

1. **Validates state** -- checks branch has a Jira key, no uncommitted changes, commits exist
2. **Runs code review** (for simple/complex tasks) -- invokes /review, blocks if issues found
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

## Behavior by task complexity

| Complexity | Review | Test verification |
|-----------|--------|-------------------|
| Trivial | Skipped | Skipped |
| Simple | Required | Required |
| Complex | Required | Required |

## Important rules

- Never commits code -- you must commit before running /finish
- Never force pushes
- If any AC is not addressed, asks for confirmation before creating PR

## Related

- [/start](start.md) -- begin a task (run this first)
- [/review](../quality/review.md) -- standalone PR review
- [/test](../quality/test.md) -- generate tests independently
