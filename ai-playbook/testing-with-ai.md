# Testing with AI

How AI generates tests at Improvs and how hooks enforce them.

## Why AI-generated tests matter

We went from zero test coverage to mandatory testing. The trick: AI writes the tests, hooks block commits without passing tests. Developers review the tests instead of writing them from scratch.

## How it works

### 1. Tests are part of every plan

When Claude creates an implementation plan, tests are explicit steps -- not an afterthought:

```
IMPLEMENTATION PLAN for PROJ-42

Code:
1. Create BiometricService
2. Add provider
3. Add screen

Tests:
4. Unit test BiometricService (enable/disable, fallback, errors)
5. Widget test BiometricScreen (renders, button taps)
6. Integration test (full flow: enable -> prompt -> success)
```

### 2. Hooks enforce testing

Before any commit goes through, these hooks fire automatically:

| Hook | What it checks |
|------|---------------|
| `flutter analyze` | Static analysis -- 0 warnings required |
| `flutter test` | All tests must pass |
| `dart format` | Code must be formatted (auto-fixed on every edit) |
| Branch name | Must contain Jira key |

If any hook fails, the commit is blocked. Claude sees the error and attempts to fix it.

### 3. Generating tests for existing code

For code that already exists without tests:

```
> Write tests for lib/features/profile/providers/profile_provider.dart.
> Cover: happy path, error states, edge cases.
> Use mocktail for mocking dependencies.
> Follow patterns in test/features/auth/ as reference.
```

## How to review AI-generated tests

AI-generated tests can look correct but test the wrong thing. Always check:

**Does it test behavior, not implementation?**
- Good: "when user submits form with invalid email, error message is shown"
- Bad: "verify setState was called with specific parameters"

**Does it cover edge cases?**
- Empty inputs, null values, network errors, timeout
- Boundary conditions (0 items, max items, very long strings)

**Does it actually fail when the code is wrong?**
- Temporarily break the code and verify the test catches it
- If a test passes with broken code, the test is useless

**Does it mock the right things?**
- External dependencies (API, database) should be mocked
- Internal logic should NOT be mocked -- test the real code

## Test structure at Improvs

```
test/
  features/
    auth/
      providers/
        auth_provider_test.dart
      screens/
        login_screen_test.dart
    profile/
      ...
  helpers/
    test_helpers.dart    -- shared mocks and utilities
```

Tests mirror the `lib/features/` structure. One test file per source file.

## When AI-generated tests aren't enough

- Complex state machines -- write these manually or pair with AI
- Visual regression tests (golden tests) -- need manual baseline approval
- Performance tests -- require real measurement, not AI estimation

For these cases, use AI to scaffold the test structure, then fill in the specifics yourself.

## Related

- [/test](skills/quality/test.md) -- independent test generation skill
- [Skills Reference](skills.md) -- all available /slash-commands
- [Developer Rules](../developer-rules/) -- commit and review standards
