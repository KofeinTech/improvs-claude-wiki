# Test Subagent

An independent QA agent that writes tests from business requirements, not from implementation knowledge. Thinks like a tester who wants to break things.

## How it's used

Invoked by the `/test` skill or automatically by `/finish` when test verification is needed. You don't call it directly.

## What it does

1. Reads the Jira ticket (acceptance criteria)
2. Reads the code changes on your branch
3. Writes tests that verify the AC is met
4. Looks for edge cases:
   - Empty/null input
   - Extremely large values
   - Network failures
   - Concurrent access
   - Invalid types
   - Boundary conditions (0, -1, MAX_INT)
   - Unexpected user behavior

## Why "independent"?

It deliberately does NOT know how the code was written. It tests what the requirements say, not what the implementation does. This catches bugs that the developer's own tests miss.

## Model

Runs on Sonnet (faster, cheaper) since it's generating tests, not complex architecture.

## Related

- [/test](test.md) -- the skill that invokes this subagent
- [/finish](finish.md) -- checks if /test was run for non-trivial tasks
