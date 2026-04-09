# Definition of Done

A task is "done" when all items on this checklist are true. No exceptions.

## Code

- [ ] Implementation matches acceptance criteria from the Jira ticket
- [ ] `flutter analyze` passes with zero warnings
- [ ] `flutter test` passes -- all existing and new tests green
- [ ] `dart format .` applied (auto-formatted by hooks)
- [ ] No hardcoded strings, secrets, or API keys in code
- [ ] No TODO comments left in committed code (finish it or create a ticket)

## Tests

- [ ] New functionality has tests (unit and/or widget tests)
- [ ] Tests verify behavior, not implementation details
- [ ] Edge cases covered: empty state, error state, boundary values

## Git

- [ ] Branch name follows convention: `PROJ-XXX-short-description`
- [ ] Commit messages follow format: `type(scope): description`
- [ ] PR created with Jira ticket link and description
- [ ] Self-reviewed the entire diff before requesting review

## Review

- [ ] PR reviewed by another developer (or `/improvs:review` skill for solo projects)
- [ ] All review comments addressed
- [ ] Squash merged to develop

## Jira

- [ ] Ticket moved to "Done" (auto via merge, but verify)
- [ ] Any unexpected findings documented (in Jira comment or wiki)

## Why this matters

Without a shared definition of done, "done" means different things to different people. One developer calls it done when the code compiles. Another calls it done when tests pass. This checklist removes ambiguity.

If you can't check every box, the task isn't done. Either finish it or split it into a new ticket for what remains.
