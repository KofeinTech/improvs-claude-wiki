# Python Coding Standards

Conventions for all Python backend projects at Improvs.

## Stack

- **FastAPI** for async web APIs
- **SQLAlchemy 2.0** with async sessions
- **Pydantic v2** for request/response validation
- **Alembic** for database migrations
- **Ruff** for linting and formatting
- **pytest** with `httpx.AsyncClient` for testing

## Project structure

```
src/
  main.py                   # FastAPI app entry point
  config.py                 # Settings via Pydantic BaseSettings
  database.py               # Engine, session factory
  features/
    users/
      router.py             # FastAPI router
      schemas.py            # Pydantic models (request/response)
      models.py             # SQLAlchemy models
      service.py            # Business logic
      repository.py         # Database queries
    orders/
      ...
  core/
    dependencies.py         # Shared DI (get_db, get_current_user)
    exceptions.py           # Custom exception handlers
    middleware.py            # Auth, logging, CORS
```

Feature-based modules. Each feature owns its router, models, schemas, service, and repository.

## Async everywhere

All handlers, services, and database calls must be `async`:

```python
@router.get("/users/{user_id}")
async def get_user(user_id: UUID, db: AsyncSession = Depends(get_db)) -> UserResponse:
    user = await user_repository.get_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse.model_validate(user)
```

## Pydantic v2 models

Separate request and response schemas:

```python
class CreateUserRequest(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: EmailStr

class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    name: str
    email: str
```

## Database

- Use Alembic for all schema changes: `alembic revision --autogenerate -m "description"`
- Never modify the database schema manually
- Use async sessions: `AsyncSession` from `sqlalchemy.ext.asyncio`
- Keep queries in repository files, not in routers

## Type hints

Type hints are mandatory on all function signatures:

```python
async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100) -> list[User]:
```

## Formatting and linting

- **Ruff** handles both linting and formatting
- Hooks auto-format on every file edit: `ruff format $FILE`
- Pre-commit hook runs: `ruff check` and `pytest`

## Testing

```python
@pytest.mark.anyio
async def test_create_user(client: AsyncClient):
    response = await client.post("/api/users", json={"name": "Test", "email": "test@example.com"})
    assert response.status_code == 201
    assert response.json()["name"] == "Test"
```

Use `httpx.AsyncClient` with `app=app` for integration tests. Use `pytest-anyio` for async test support.

## Don't

- Don't use sync database calls -- always `await`
- Don't put business logic in routers -- use service layer
- Don't use `from module import *`
- Don't ignore type hints -- Ruff enforces them
- Don't write raw SQL unless SQLAlchemy can't express the query
