# Rule: Plan Before Code

Before implementing, create a plan. Review it. Adjust it. Only then write code.

## Why

Jumping straight to code leads to architectural mistakes, wasted effort, and PRs that need to be rewritten. 15 minutes of planning saves hours of rework. This is especially important when using AI -- Claude will happily build the wrong thing fast if you don't guide it.

## What to do

1. Read the Jira ticket requirements carefully
2. Ask Claude to create a plan (use `/feature` skill or plan mode)
3. Review the plan -- check that it covers edge cases, tests, and matches the architecture
4. Adjust if needed
5. Only then proceed to implementation

## What a plan should include

- Files to create or modify
- Data model changes (if any)
- API contract (if applicable)
- Test cases to write
- Dependencies or blockers
