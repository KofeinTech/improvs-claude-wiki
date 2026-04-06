# /start -- Begin a Task

Read a Jira ticket, evaluate complexity, create a branch, and begin working. This is the standard entry point for any new task.

## Usage

```
/start <JIRA_TICKET_KEY>
```

Example: `/start PINK-42`

## Who uses this

Every developer starting work on a Jira ticket.

## What happens when you run it

1. **Reads the Jira ticket** -- title, description, acceptance criteria, linked tickets
2. **Checks for UI changes** -- scans for UI keywords, asks for Figma URL if found
3. **Reads Figma design** (if provided) -- extracts layout, spacing, colors, typography
4. **Creates a branch** -- checks for uncommitted changes first, pulls latest base branch
5. **Evaluates task complexity**:
   - **Trivial** -- 1 file, cosmetic/config change, 1 AC (no TDD needed)
   - **Simple** -- 1-2 files, single layer, 1-3 AC (TDD: red-green-refactor)
   - **Complex** -- 3+ files, multiple layers, 4+ AC (full pipeline with planning)
6. **Moves Jira to In Progress** -- adds comment with start timestamp and complexity
7. **Presents summary** and begins work based on complexity level

## Complexity classification

| Level | What it means | Workflow |
|-------|--------------|----------|
| Trivial | Typo, config, color change | Direct fix, no TDD, no /test needed |
| Simple | Bugfix, add field, simple endpoint | TDD cycle (failing test first) |
| Complex | New feature with multiple layers | Full pipeline with brainstorming and planning |

## Important rules

- Never starts coding without reading the Jira ticket first
- Refuses to proceed without acceptance criteria on the ticket
- Records task start in Jira comment with complexity classification
- If you're already on a matching branch, asks whether to continue

## After /start

Code your task, then run `/finish` when done.

## Related

- [/quickfix](quickfix.md) -- for trivial tasks that don't need full /start ceremony
- [/finish](finish.md) -- complete the task after coding
- [/bug](bug.md) -- for bug tickets specifically (investigation-first)
