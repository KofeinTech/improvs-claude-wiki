# Python Coding Standards

Conventions for Python backend projects at Improvs. Both **FastAPI** and **Django** are acceptable -- use whichever is already in the project, or follow `CLAUDE.md` for new projects.

These conventions are enforced automatically by the rules deployed to your `.claude/rules/` folder. This page is the human-readable version.

## Stack (non-negotiable)

- **Python** -- latest stable version
- **Package manager** -- `uv` (never pip, never poetry)
- **Database** -- PostgreSQL
- **Linter + formatter** -- Ruff (single tool, replaces black + flake8)
- **Testing** -- pytest (use `pytest-django` for Django projects, not Django's built-in TestCase)
- **Logging** -- standard `logging` module, **never `print()`**
- **Background tasks** -- Celery + Redis
- **Everything runs through docker-compose** -- never run commands on the host

## Web framework -- pick one

### FastAPI

For greenfield async APIs. Stack:

- **FastAPI** for routing
- **SQLAlchemy 2.0** with async sessions (see SQLAlchemy section -- this is the part Claude gets wrong most often)
- **Pydantic v2** for request/response validation
- **Pydantic Settings** for config (not python-dotenv)
- **Alembic** for database migrations

### Django

For projects that need Django's batteries-included ecosystem (admin, ORM, auth out of the box).

- **DRF or Django Ninja** for the API layer -- both acceptable, follow whichever is already in the project
- **Django ORM** with `select_related()` / `prefetch_related()` to prevent N+1
- **Django migrations** (built-in, not Alembic)
- **drf-spectacular** for OpenAPI auto-gen if using DRF, or Django Ninja's built-in `/api/docs`

## Project structure

### FastAPI

```
project/
  app/
    core/
      config.py             # Pydantic Settings, reads .env
      database.py           # async engine, session factory
      security.py           # JWT, password hashing
      exceptions.py         # custom exception hierarchy
      dependencies.py       # shared DI (auth, db session)
    features/
      users/
        router.py           # HTTP + validation + auth (calls service)
        schemas.py          # Pydantic request/response (one per use case)
        models.py           # SQLAlchemy models
        service.py          # business logic
      orders/
        ...
    tasks/                  # Celery tasks (if needed)
    main.py
  tests/
    conftest.py
    features/
      users/
        test_router.py
        test_service.py
  migrations/               # Alembic
  Dockerfile
  docker-compose.yml
  pyproject.toml
```

### Django

```
project/
  project_name/             # same name as project (e.g., myshop/)
    settings.py             # single file, env vars for per-environment config
    urls.py
    wsgi.py
    asgi.py
    celery.py               # if background tasks needed
  users/                    # apps at ROOT level, not in apps/ folder
    models.py
    views.py                # or viewsets.py for DRF
    serializers.py
    services.py             # business logic
    urls.py
    admin.py
    tests/
      test_views.py
      test_services.py
  orders/
    ...
  common/                   # shared utilities
    models.py               # abstract base models (timestamps, soft delete)
    permissions.py
    exceptions.py
  manage.py
  Dockerfile
  docker-compose.yml
  pyproject.toml
```

Feature-based modules in both. Each feature owns its own router/views, schemas/serializers, models, and service.

## Architecture (mandatory)

**Service layer is mandatory.** Business logic belongs in services, never in routers/views.

- **router/view** -- HTTP only. Validation, auth, calls service. No business logic, no SQL.
- **service** -- business logic. Uses SQLAlchemy/ORM directly.
- **schemas/serializers** -- one per use case. Never reuse the same schema for create and response.
- **models** -- table definitions only. No business logic.

There is **no separate repository layer**. The service uses SQLAlchemy/Django ORM directly. (Don't add a repository pattern unless the project's CLAUDE.md explicitly says so.)

## SQLAlchemy 2.0 (FastAPI projects -- CRITICAL)

Claude often gets these wrong. The rules are non-negotiable:

- **Always use `AsyncSession`**, never sync `Session`
- **Always use `select()` style**, never the old `query()` style
- **Always use `selectinload()`** for eager loading (not `joinedload` for collections)
- **Always use `mapped_column()`** with type annotations (not bare `Column`)
- **Use `DeclarativeBase`**, not the old `declarative_base()`

```python
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = "users"
    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    email: Mapped[str] = mapped_column(unique=True, index=True)

# Query
result = await session.execute(select(User).where(User.email == email))
user = result.scalar_one_or_none()
```

## Django ORM

- Use `select_related()` for ForeignKey (prevents N+1)
- Use `prefetch_related()` for ManyToMany (prevents N+1)
- Use `.exists()` instead of `len(queryset) > 0`
- Use `.count()` instead of `len(queryset)`
- Never use `.all()` without `.only()` or limit in views
- Use `F()` and `Q()` objects for complex queries, never raw SQL
- Always commit migrations -- never gitignore them. Never edit existing migrations -- create new ones.

## Conventions

- `from __future__ import annotations` in every file
- `pathlib.Path` instead of `os.path`
- `Enum` for fixed choices, never magic strings
- No wildcard imports (`from module import *`)
- API versioning: always `/api/v1/` prefix
- `model_config = {"from_attributes": True}` on every Pydantic response schema (FastAPI)

## Code rules

- Type hints on function signatures and return types. Not required for obvious locals.
- No `print()` -- use `logging`
- No bare `except:` -- catch specific exceptions
- No hardcoded secrets -- everything from env vars
- No mutable default arguments -- use `None` and `if arg is None:`
- Max function length: ~30 lines. Extract helpers above that.

## Configuration

**FastAPI** -- Pydantic Settings, not python-dotenv:

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    jwt_secret: str
    debug: bool = False
    model_config = ConfigDict(env_file=".env")
```

**Django** -- single `settings.py`, env vars for per-environment config. Crash on missing required vars:

```python
import os
DEBUG = os.getenv("DEBUG", "False").lower() == "true"
SECRET_KEY = os.environ["SECRET_KEY"]  # crash if missing
```

## Testing

- pytest with fixtures in `conftest.py`
- Test naming: `test_<what>_<scenario>_<expected>`
- AAA pattern: Arrange, Act, Assert
- Use factories for test data, not raw model construction
- Run via docker-compose: `docker-compose exec app pytest -v`
- Django projects: pytest + `pytest-django`, never Django's built-in `TestCase`

```python
@pytest.mark.anyio
async def test_create_user_with_valid_email_returns_201(client: AsyncClient):
    response = await client.post("/api/v1/users", json={"name": "Test", "email": "test@example.com"})
    assert response.status_code == 201
    assert response.json()["name"] == "Test"
```

## Ruff config

`pyproject.toml`:

```toml
[tool.ruff]
line-length = 120

[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP", "B", "SIM", "RUF"]
```

Hooks auto-format on every file edit (`ruff format $FILE`). Pre-commit hook runs `ruff check` and `pytest` -- both must pass before a commit lands.

## Docker

- Always `docker-compose.yml` (dev) + `docker-compose.prod.yml` (production overrides)
- Minimum services: `app` + `db`. Add `redis` + `celery-worker` when needed.
- Multi-stage Dockerfile: builder installs deps, runtime copies `.venv` only
- Always `python:X.XX-slim` base -- never full, never alpine (musl breaks packages)
- Copy `pyproject.toml` + `uv.lock` FIRST, then code (layer caching)
- Non-root user in production
- `HEALTHCHECK` required
- `.dockerignore` required: `.git`, `__pycache__`, `.venv`, `.env`, `.pytest_cache`

## Migrations

**FastAPI / Alembic**:

```bash
docker-compose exec app alembic revision --autogenerate -m "description"
docker-compose exec app alembic upgrade head
```

**Django**:

```bash
docker-compose exec app python manage.py makemigrations
docker-compose exec app python manage.py migrate
```

Always commit migrations. Never gitignore them. Never edit existing migrations -- create new ones.

## API documentation

- **FastAPI** auto-generates Swagger at `/docs` and ReDoc at `/redoc`. **Don't** write API docs manually -- reference the auto-generated docs in the README.
- **Django + DRF** -- configure `drf-spectacular` for OpenAPI auto-gen. **Don't** write manually.
- **Django Ninja** auto-generates at `/api/docs`. **Don't** write manually.

## Don't

- Don't use sync database calls in FastAPI -- always `await`
- Don't put business logic in routers/views -- use the service layer
- Don't add a repository layer unless `CLAUDE.md` explicitly says so
- Don't use `print()` -- use `logging`
- Don't use bare `except:` -- catch specific exceptions
- Don't use mutable default arguments
- Don't write functions longer than ~30 lines
- Don't use `from module import *`
- Don't write raw SQL unless the ORM cannot express the query
- Don't run commands on the host -- everything goes through `docker-compose exec`
