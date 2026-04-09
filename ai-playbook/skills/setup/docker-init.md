# /improvs:docker-init -- Docker Setup

Generate Dockerfile, docker-compose.yml, docker-compose.prod.yml, and .dockerignore for a project. Auto-detects the stack and required services.

## Usage

```
/improvs:docker-init
```

No arguments -- detects everything from project files.

## Who uses this

Developers setting up Docker for a new or existing project.

## What happens when you run it

1. **Checks for existing Docker files** -- asks whether to overwrite or skip
2. **Detects the stack** -- from pyproject.toml, package.json, or *.csproj (Flutter projects are not Dockerized)
3. **Detects required services** -- scans dependencies for databases, caches, queues:
   - PostgreSQL (always included)
   - Redis (if celery or redis dependency found)
   - Elasticsearch, RabbitMQ (if dependencies found)
4. **Generates files**:
   - `Dockerfile` -- multi-stage build for the detected stack
   - `docker-compose.yml` -- development setup with all services
   - `docker-compose.prod.yml` -- production overrides
   - `.dockerignore` -- excludes build artifacts, tests, docs

## Related

- [/improvs:docs](docs.md) -- generate project documentation including deployment guide
