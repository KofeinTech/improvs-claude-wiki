# /improvs:start -- Begin a Task

Read a Jira ticket, evaluate complexity, create a branch, and begin working. This is the **single entry point** for every task -- features, bugs, hotfixes, refactors, everything.

## Usage

```
/improvs:start <JIRA_TICKET_KEY>
```

Example: `/improvs:start PINK-42`

## Who uses this

Every developer starting work on a Jira ticket.

## What happens when you run it

1. **Reads the Jira ticket** -- title, description, acceptance criteria, type, linked tickets
2. **Bug investigation (Bug tickets only)** -- if the ticket type is `Bug`, Claude searches the codebase for the likely root cause and prints an `INVESTIGATION` block with a confidence rating before going further. For non-Bug tickets, this step is skipped.
3. **Evaluates task complexity** -- classifies as Trivial / Simple / Complex based on objective signs (file count, layers, AC count, new screens, integrations, etc.)
4. **Checks for UI changes** -- scans for UI keywords, asks for the Figma URL if found (skipped on trivial tasks)
5. **Creates a branch** -- pulls latest base branch, creates `<JIRA_KEY>-<short-description>`. Branch name is auto-generated for trivial tasks.
6. **Moves Jira to In Progress** -- adds a comment with start timestamp and the complexity classification
7. **Presents summary and routes execution** based on complexity:
   - **Trivial** -- direct edit, no TDD, no review, no test
   - **Simple** -- automatically invokes `superpowers:test-driven-development` (red-green-refactor)
   - **Complex** -- automatically invokes `superpowers:brainstorming`, which chains into `writing-plans` and `executing-plans`

## Complexity classification

| Level | Signs | What happens next |
|-------|-------|-------------------|
| Trivial | 1 file, cosmetic/text/config change, 1 AC, no logic | Direct edit. No TDD, no /improvs:review, no /improvs:write-tests. |
| Simple | 1-2 files, single layer, 1-3 AC | `superpowers:test-driven-development` is invoked automatically (failing test first) |
| Complex | 3+ files OR multi-layer OR 4+ AC OR new screen / state / integration / migration | `superpowers:brainstorming` is invoked automatically (brainstorm -> plan -> execute) |

There is **no yes/no prompt** before the superpowers skills run. The classification *is* the decision. If you disagree with how Claude classified your task, just say so the moment you see the classification block ("actually this is simple, skip brainstorming") and Claude will switch tracks.

## Bug ticket flow

When the Jira ticket type is `Bug`, Claude does an extra investigation step *before* classifying complexity. This exists because bug descriptions usually don't reveal scope -- "login is broken on Android 14" could be a 1-line fix or a 3-file refactor, and Claude needs to read the code to know which.

### Example session

```
> /improvs:start PINK-55

Reading PINK-55: "App crashes when user taps notifications on Android 14"
Type: Bug | Priority: High
Steps to reproduce: 1. Receive push notification  2. Tap it  3. Crash
Expected: app opens to relevant screen
Actual: app crashes immediately

INVESTIGATION: PINK-55
Likely root cause: lib/features/notifications/handlers/push_handler.dart (~line 38)
Reason: The notification payload is not null-checked before accessing .data
Confidence: High

Complexity: Simple (1 file, single layer, 2 AC)

Branch: PINK-55-fix-notification-tap-crash
Jira: moved to In Progress

READY TO START
━━━━━━━━━━━━━━
Mode: TDD (superpowers:test-driven-development)

Invoking superpowers:test-driven-development via the Skill tool.
[TDD cycle begins: failing test for null payload, then null check fix]
```

The `INVESTIGATION` block is a forced output checkpoint -- you read it before Claude touches any code, so you can catch a wrong root cause guess immediately.

## Important rules

- Refuses to start without acceptance criteria on the ticket
- Refuses to start with uncommitted changes in the working tree
- Records task start in a Jira comment with the complexity classification (used by `/improvs:finish` later)
- For trivial tasks: no Figma URL question, auto-generates the branch name
- If you're already on a branch matching the ticket key, asks whether to continue on it

## After /improvs:start

Code your task, then run `/improvs:finish` when done. For simple/complex tasks, `/improvs:finish` will automatically run `/improvs:review` and check that test files were added before pushing.

## Related

- [/improvs:finish](finish.md) -- complete the task after coding
- [/improvs:review](../quality/review.md) -- standalone code review (also auto-invoked by /improvs:finish)
- [/improvs:write-tests](../quality/write-tests.md) -- independent test generation
