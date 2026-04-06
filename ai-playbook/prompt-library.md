# Prompt Library

Ready-to-use prompts for common development tasks. Copy, adapt, and use.

## Feature development

### Scaffold a new feature

```
Create a new feature module for [feature name] under lib/features/.
Follow the same structure as lib/features/[existing feature]/.
Include: providers, screens, widgets directories.
Create a basic Riverpod provider and an empty screen with GoRouter route.
Add widget tests for the screen.
```

### Implement from Jira ticket

```
Jira ticket [PROJ-XXX]: [ticket title]
Acceptance criteria:
- [criterion 1]
- [criterion 2]

Figma design: [paste Figma link if UI changes]

Create a plan first. Include tests as explicit steps in the plan.
```

## Bug fixing

### Investigate and fix a bug

```
Bug: [describe the symptom]
Steps to reproduce: [steps]
Expected: [what should happen]
Actual: [what happens instead]

Find the root cause before fixing. Explain what's wrong and why before writing code.
```

### Fix with minimal changes

```
Fix [specific issue] in [file path].
Change only what's necessary. Don't refactor surrounding code.
Add a regression test that fails before the fix and passes after.
```

## Testing

### Generate tests for existing code

```
Write tests for lib/features/[feature]/providers/[provider].dart.
Cover: happy path, error states, edge cases, null inputs.
Use flutter_test and mocktail for mocking.
Follow the test patterns in test/features/[existing tests]/.
```

### Add integration test

```
Write an integration test for the [flow name] flow:
1. [step 1]
2. [step 2]
3. [expected result]

Use the integration_test package. Follow existing patterns in integration_test/.
```

## Code review

### Review current changes

```
Review all changes in the current branch (git diff).
Check for:
- Business logic correctness
- Security issues (hardcoded secrets, SQL injection, XSS)
- Missing error handling
- Missing tests
- Convention violations (check .claude/rules/)
- Unnecessary complexity

List issues by severity: critical, warning, suggestion.
```

## Refactoring

### Safe refactor

```
Refactor [describe what] in [file/directory].
Goal: [what should be better after refactoring]

Rules:
- Run tests before and after each change
- Make one change at a time
- If any test fails, fix before continuing
- Don't change behavior, only structure
```

## API development

### Create API endpoint (.NET)

```
Create a new API endpoint: [HTTP method] /api/[path]
Request body: [describe fields]
Response: [describe response]

Follow Clean Architecture:
- Command/Query in Application layer (MediatR handler)
- Validation in FluentValidation
- Controller in API layer
- Add unit tests for the handler
```

### Create API endpoint (Python)

```
Create a new FastAPI endpoint: [HTTP method] /api/[path]
Request model: [describe fields]
Response model: [describe response]

Use Pydantic v2 models, async handler, SQLAlchemy for DB access.
Add pytest tests with httpx AsyncClient.
```

## Related

- [Best Practices](best-practices.md) -- how to prompt effectively
- [Tips and Tricks](tips-and-tricks.md) -- efficient prompting section
- [Skills Reference](skills.md) -- shared skills may already cover your use case
