# Rule: Test Before PR

Run tests and static analysis locally before creating a PR.

## Why

Pushing broken code wastes reviewer time and CI resources. If tests fail on CI, your PR sits in limbo while you fix it, blocking the review queue. Running tests locally takes 2 minutes and catches 90% of issues.

## What to do

Before creating a PR, run the checks for your project type:

**Flutter:** `fvm flutter analyze --no-fatal-infos` + `fvm flutter test`

**.NET:** `dotnet build` + `dotnet test`

**Python:** `ruff check .` + `pytest`

These same checks are enforced by Claude Code hooks before every commit. But if you're committing outside Claude Code (manual git), run them yourself.
