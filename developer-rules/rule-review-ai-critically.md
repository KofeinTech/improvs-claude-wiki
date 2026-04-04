# Rule: Review AI Output Critically

AI generates plausible-looking code that may be wrong. Treat every AI output as a draft that needs human verification.

## Why

Claude writes confident, well-formatted code that often works. But it can also hallucinate APIs, introduce subtle logic errors, miss edge cases, add unnecessary complexity, or create security vulnerabilities -- all while looking completely correct. Your job is to catch these.

## What to check

- **Business logic** -- does the code actually do what the ticket asks?
- **Edge cases** -- what happens with empty input, null values, concurrent access?
- **Error handling** -- are errors caught and handled properly?
- **Security** -- SQL injection, XSS, exposed secrets, missing auth checks?
- **Unnecessary complexity** -- did Claude over-engineer a simple task?
- **Dependencies** -- did Claude add packages you don't need?

## Golden rule

If you don't understand a line of code, don't commit it. Ask Claude to explain it or rewrite it simpler.
