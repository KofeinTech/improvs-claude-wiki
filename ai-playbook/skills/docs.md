# /docs -- Project Documentation

Generate or update project documentation. Covers README, API docs, architecture, deployment guide, environment variables, and database schema.

## Usage

```
/docs [type]
```

Types: `all`, `readme`, `api`, `architecture`, `deploy`, `env`, `schema`

Example:
- `/docs` -- generate all documentation
- `/docs readme` -- just the README
- `/docs api` -- just the API docs

## Who uses this

Developers or leads who need to create or update project documentation.

## What it generates

| Type | Output | What's in it |
|------|--------|-------------|
| readme | README.md | Project overview, setup, commands, structure |
| api | docs/API.md | Endpoints, request/response, auth |
| architecture | docs/ARCHITECTURE.md | Layers, patterns, key decisions |
| deploy | docs/DEPLOYMENT.md | How to deploy, environments, CI/CD |
| env | .env.example | All environment variables with descriptions |
| schema | docs/SCHEMA.md | Database tables, relations, migrations |

## Related

- [/docker-init](docker-init.md) -- set up Docker (referenced by deployment docs)
- [/onboard](onboard.md) -- uses these docs to brief new team members
