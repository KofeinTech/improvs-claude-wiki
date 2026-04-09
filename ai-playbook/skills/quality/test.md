# /improvs:test -- Independent Test Generation

Generate tests from Jira acceptance criteria, not from implementation knowledge. Finds edge cases and potential bugs that the developer might have missed.

`/improvs:test` is a thin wrapper that dispatches the **`test` subagent** -- a fresh-context Sonnet agent with no visibility into your implementation conversation. The independence is the entire point: the subagent cannot be biased by what you just built, so it tests what the AC says the code *should* do, not what the code *actually* does.

## Usage

```
/improvs:test
```

No arguments -- tests the current branch changes.

## Who uses this

Developers who want independent test verification before running `/improvs:finish`.

## What happens when you run it

1. **Reads the Jira ticket** from the branch name
2. **Analyzes the code changes** on the current branch
3. **Writes tests based on acceptance criteria** -- not on how the code was written
4. **Looks for edge cases** -- empty input, null values, boundaries, concurrent access, network failures
5. **Reports findings** -- new tests added, potential bugs found

## Why "independent"?

The test subagent thinks like a QA engineer who hasn't seen the implementation. It tests what the business requirements say, not what the code does. This catches:

- Cases where code works but doesn't match the AC
- Edge cases the developer didn't think about
- Missing error handling
- Boundary conditions

## When is /improvs:test required?

| Task complexity | /improvs:test required? |
|----------------|----------------|
| Trivial | No |
| Simple | Yes (checked by /improvs:finish) |
| Complex | Yes (checked by /improvs:finish) |

If you skip /improvs:test, the PR will be flagged with a warning.

## Related

- [/improvs:finish](../workflow/finish.md) -- runs /improvs:test automatically if tests are missing
- [/improvs:start](../workflow/start.md) -- sets task complexity that determines if /improvs:test is required
