# /bug -- Bug Fix Flow

Investigate and fix a bug from a Jira ticket. Claude leads with investigation, not coding.

## Usage

```
/bug <JIRA_TICKET_KEY>
```

Example: `/bug PINK-55`

## Who uses this

Developers assigned to fix a bug.

## What happens when you run it

1. **Claude reads the Jira ticket** -- pulls description, reproduction steps, expected vs actual behavior, environment
2. **Claude searches the codebase** -- finds the likely root cause and shows you which files/lines are suspect
3. **Creates a branch** -- `bugfix/PINK-55-short-description`
4. **Moves ticket to In Progress** on Jira and starts tracking time
5. **Shows you a short fix plan** -- asks for confirmation before writing any code
6. **Writes a failing test first** -- proves the bug exists before fixing it
7. **Fixes the bug** -- targeted fix only, no extra changes
8. **Runs tests** -- verifies the fix and checks for regressions

## What you do after

Run `/finish` to push, create a PR, and update Jira.

## What Claude will ask you

- If the ticket has no reproduction steps: "How do you trigger this bug?"
- If the root cause is unclear: "I found two possible causes. Can you help narrow it down?"
- If the bug is actually a feature request: Claude will tell you and suggest creating a new ticket

## Key rules

- Claude always writes a failing test before writing the fix
- The fix is minimal -- no refactoring, no cleanup of surrounding code
- If the bug can't be reproduced in a test (race condition, device-specific), Claude documents why

## Example session

```
> /bug PINK-55

Reading PINK-55: "App crashes when user taps notifications on Android 14"
Steps to reproduce: 1. Receive push notification  2. Tap it  3. Crash

INVESTIGATION: PINK-55
Likely root cause: lib/features/notifications/handlers/push_handler.dart (~line 38)
Reason: The notification payload is not null-checked before accessing .data
Confidence: High

FIX PLAN for PINK-55
1. Write failing test: push_handler receives null payload
2. Fix null check in push_handler.dart:38
3. Verify test passes
4. Run full test suite

Confirm? yes

[Claude writes test, fixes code, runs tests -- all pass]

Done. Run /finish to create PR and update Jira.
```

## Related

- [/hotfix](hotfix.md) -- for production emergencies (branches from main)
- [/start](../workflow/start.md) -- for new features (includes Figma, planning)
