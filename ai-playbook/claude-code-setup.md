# Claude Code Setup

How to install and configure Claude Code for Improvs development.

## Install the CLI

```bash
# macOS
npm install -g @anthropic-ai/claude-code

# Verify
claude --version
```

## Login with your Improvs account

```bash
claude
# Select "Sign in with Claude.ai"
# Login with your @improvs.com Google account
```

Your Improvs organization membership is automatic via Google Workspace SSO. You will see "Improvs" as your organization in the settings.

## What happens automatically

Once you're in the org, these are deployed to your machine:

**Managed settings** (org-wide, you cannot override):
- Permission denies: `sudo`, `rm -rf`, reading `.env` / `.key` / `.pem` / `credentials` files
- Force push is blocked
- Bypass permissions mode is disabled

**Quality hooks** (fire on every commit):
- `flutter analyze` must pass before commit
- `flutter test` must pass before commit
- Branch name must contain a Jira key (e.g., `PINK-42-...`)
- `dart format` runs automatically on every file edit

**Rules** (loaded based on project type):
- Global rules (git workflow, behavior, security)
- Flutter rules (if `pubspec.yaml` detected)
- .NET rules (if `.csproj` detected)
- Python rules (if `pyproject.toml` detected)

## MCP servers

Organization-wide MCP servers connect Claude Code to our tools:

| Server | What it does |
|--------|-------------|
| Jira | Read/update tickets, log time |
| GitHub | Enhanced repo interaction |
| Figma | Read design specs for code generation |
| Google Sheets | Access project data, budgets |

These are configured at the org level. No setup needed on your end.

## Verify your setup

Run this in any project directory:

```bash
claude
> What hooks and rules are active in this session?
```

Claude should list the quality hooks, rules loaded, and MCP servers available. If anything is missing, contact the CEO.

## Project-level config

Each project also has its own `CLAUDE.md` in the repo root with:
- Project stack and commands
- Directory structure
- Project-specific conventions

This is loaded automatically when you open Claude Code in that directory.
