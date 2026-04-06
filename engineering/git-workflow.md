# Git Workflow

How we use Git at Improvs. Branch naming, commits, PRs, and protection rules.

## Branch naming

Every branch must reference a Jira ticket:

```
<JIRA-KEY>-<short-description>

Examples:
PINK-42-add-user-auth
CUE-108-fix-chat-scroll
SOL-7-setup-riverpod
```

A hook validates this when you create the branch (`git checkout -b` or `git switch -c`). Branches that don't match the pattern are refused at creation time. Once you're on a valid branch, commits run a separate set of hooks (analyze + tests).

## Commit messages

```
<type>(<scope>): <description>

Types: feat, fix, refactor, test, docs, chore, style, perf
```

Examples:
```
feat(auth): add biometric login for iOS
fix(chat): resolve message ordering on slow connections
refactor(theme): extract color constants to design tokens
test(profile): add widget tests for profile edit screen
```

## Pull requests

Every change goes through a PR. No direct pushes to `main` or `develop`.

### PR template

Every repo includes `.github/pull_request_template.md`:

```markdown
## Jira Ticket
[PROJ-XXX](https://improvs.atlassian.net/browse/PROJ-XXX)

## What Changed
<!-- Brief description -->

## Screenshots / Screen Recording
<!-- For UI changes -->

## Testing
- [ ] Project's analyze/lint command passes (`fvm flutter analyze` / `dotnet build` / `ruff check`)
- [ ] All tests pass
- [ ] New tests added for new functionality
- [ ] Manual testing completed

## Checklist
- [ ] Self-reviewed the diff
- [ ] No hardcoded strings, secrets, or API keys
- [ ] Branch name follows convention
```

### Review process

- **Teams with 2+ devs:** another developer reviews the PR
- **Solo projects (Fantabase, TradingSim):** mandatory `/review` skill run + thorough self-review. CEO spot-checks periodically.

## Branch protection

### `main` branch
- Require PR with 1 approval minimum
- Require status checks: `flutter analyze`, `flutter test`, build
- Require branches up to date before merge
- Block force pushes (for everyone, no exceptions)
- Block branch deletion

### `develop` branch
- Require PR with 1 approval
- Require status checks to pass

## Merge strategy

Squash merge to `develop`. This keeps history clean -- one commit per feature.

## Force push

Blocked. Always. The hook returns: "BLOCKED: force push is not allowed." There are no exceptions.
