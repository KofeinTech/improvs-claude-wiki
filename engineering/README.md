# Engineering

Standards, workflows, and conventions for all Improvs development.

## Guides

| Guide | Description |
|-------|-------------|
| [Tech Stack](tech-stack.md) | Flutter, .NET, Python -- tools and versions we use |
| [Git Workflow](git-workflow.md) | Branch naming, commits, PRs, branch protection |
| [Code Review](code-review-guidelines.md) | What reviewers check, solo project rules, AI review |
| [Security](security-guidelines.md) | Secrets management, OWASP, incident response |

## Coding Standards

| Standard | Stack |
|----------|-------|
| [Flutter / Dart](coding-standards/flutter-dart.md) | Riverpod, Freezed, GoRouter, feature structure |
| [C# / .NET](coding-standards/backend-csharp.md) | Clean Architecture, MediatR, EF Core, CQRS |
| [Python](coding-standards/backend-python.md) | FastAPI, SQLAlchemy, Pydantic v2, async |

## Key principle

Hooks enforce quality at the system level. Every commit must pass `flutter analyze` and `flutter test`. AI generates the tests; you review them. CI/CD confirms what hooks already checked.
