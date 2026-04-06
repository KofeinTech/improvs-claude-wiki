# Tech Stack

Technologies and tools used across Improvs projects.

## Mobile (primary)

| Tool | Purpose |
|------|---------|
| Flutter | Cross-platform mobile framework (iOS + Android) |
| FVM | Flutter version management per project |
| Riverpod | State management (all projects) |
| GoRouter | Navigation and routing |
| Freezed | Immutable data models with code generation |
| Dio | HTTP client for API calls |
| flutter_svg | SVG rendering for icons |
| flutter_screenutil | Responsive scaling across devices |
| mocktail | Mocking for tests |

## Backend (.NET)

| Tool | Purpose |
|------|---------|
| ASP.NET Core | Web API framework |
| Entity Framework Core | ORM and database access |
| MediatR | CQRS pattern, command/query handlers |
| FluentValidation | Input validation |
| Serilog | Structured logging |
| xUnit | Testing framework |

## Backend (Python)

Both FastAPI and Django are acceptable -- pick whichever fits the project. Greenfield async APIs lean FastAPI; projects that want Django's batteries-included ecosystem (admin, auth, ORM out of the box) use Django.

| Tool | Purpose |
|------|---------|
| uv | Package manager (never pip, never poetry) |
| FastAPI | Async web framework (option A) |
| Django + DRF or Django Ninja | Batteries-included framework (option B) |
| SQLAlchemy 2.0 | ORM with async support (FastAPI) |
| Pydantic v2 | Data validation and serialization (FastAPI) |
| Alembic | Database migrations (FastAPI) |
| Django ORM + migrations | Built-in (Django) |
| Celery + Redis | Background tasks |
| Ruff | Linting and formatting |
| pytest (+ pytest-django for Django) | Testing framework |

## Frontend (landings)

| Tool | Purpose |
|------|---------|
| HTML/CSS/JS | improvs.com website, landing pages |

## Infrastructure

| Tool | Purpose |
|------|---------|
| GitHub (Team plan) | Source code, PRs, CI/CD via Actions |
| Jira (Cloud Standard) | Project management, sprint tracking |
| Claude Code (Team) | AI-assisted development |
| Azure | Cloud hosting (ACI, ACR) |
| Figma | Design, prototyping, handoff |
| Google Workspace | Email, calendar, docs (@improvs.com) |
| Telegram | Team communication |
