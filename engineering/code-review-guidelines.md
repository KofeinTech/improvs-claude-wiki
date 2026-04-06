# Code Review Guidelines

What to check when reviewing PRs and how AI-assisted review works.

## Why we review

AI-generated code can increase issue counts by 1.7x without governance. Human review is the quality gate. Every PR gets reviewed before merge -- no exceptions.

## What reviewers check

### Critical (must fix before merge)

- **Business logic:** Does the code do what the ticket asks? Are acceptance criteria met?
- **Security:** No hardcoded secrets, no SQL injection, no XSS, no command injection
- **Data handling:** Correct null checks, error handling for network failures, edge cases
- **Tests:** Do tests actually verify the right behavior? Would they fail if the code was wrong?

### Important (should fix)

- **Conventions:** Follows the coding standards for the project's stack ([Flutter](coding-standards/flutter-dart.md), [.NET](coding-standards/backend-csharp.md), or [Python](coding-standards/backend-python.md))
- **Architecture:** Feature in the right directory, correct layer separation, no circular dependencies
- **Naming:** Variables, functions, and files have clear, descriptive names
- **Complexity:** No unnecessary abstractions, no over-engineering

### Nice to have (optional)

- Performance optimizations
- Better variable names
- Minor code style improvements

## Solo project review

Projects with one developer (Fantabase, TradingSim) cannot have peer review. Instead:

1. **Run `/review` skill** before every PR -- AI checks security, performance, conventions, test coverage
2. **Self-review the entire diff** line by line -- read it as if someone else wrote it
3. **CEO spot-checks** periodically

## AI-assisted review

Run `/review` to get a structured review of the current branch:

```
> /review
```

The skill hard-blocks any hardcoded secrets, dispatches the superpowers code reviewer with the Jira AC + project rules as the spec, then verifies the diff actually covers every AC item. Output is in your terminal -- nothing is posted to GitHub. See [/review skill](../ai-playbook/skills/quality/review.md) for full details.

AI review supplements human review. It does not replace it. AI catches patterns humans miss (security, convention violations). Humans catch logic errors AI misses (wrong business rules, unnecessary complexity).

## Review etiquette

- Review within 24 hours of being assigned
- Be specific: "this null check is missing on line 42" not "needs more error handling"
- Approve when issues are minor and you trust the author to fix them
- Block only for critical issues
