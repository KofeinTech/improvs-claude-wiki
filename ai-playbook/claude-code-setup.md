# Claude Code Setup

How to install and configure Claude Code for Improvs development.

## Quick setup (recommended)

Run the setup script. It handles everything in one go:

```bash
# Download and run
curl -sO https://raw.githubusercontent.com/KofeinTech/improvs-claude-wiki/main/setup-developer.sh
chmod +x setup-developer.sh
./setup-developer.sh
```

What the script does:
1. Installs Node.js (if missing)
2. Installs Claude Code CLI
3. Logs you into the Improvs Claude organization
4. Sets up GitHub MCP (opens browser to create a Personal Access Token)
5. Sets up Atlassian/Jira MCP (OAuth login in browser)
6. Installs Figma MCP plugin (authenticate later via `/mcp`)

The script guides you through each step interactively -- it opens browser windows and waits for you to complete each action before moving on. Works on macOS, Linux, and Windows (WSL).

## Manual setup

If you prefer to set up manually or the script is not available:

### 1. Install the CLI

```bash
# macOS (with Homebrew)
brew install node    # if Node.js is not installed
npm install -g @anthropic-ai/claude-code

# Linux
sudo apt-get install nodejs npm
npm install -g @anthropic-ai/claude-code

# Verify
claude --version
```

### 2. Login with your Improvs account

```bash
claude login
```

This opens a browser window. Log in with the account that was invited to the Improvs Claude Team organization. If you don't have an account yet, ask your manager for an invitation.

### 3. Set up MCP servers

MCP servers connect Claude Code to Jira, GitHub, and Figma. Each developer must set these up on their own machine.

All `claude mcp` and `claude plugin` commands below are run in your **regular terminal** (not inside a Claude Code session).

**GitHub MCP** -- lets Claude read repos, create PRs, manage issues:

1. Go to https://github.com/settings/tokens/new?scopes=repo,read:org,read:user&description=Claude+Code+MCP
2. Generate a Personal Access Token (classic) with scopes: `repo`, `read:org`, `read:user`
3. Copy the token and run in your terminal:
```bash
claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_TOKEN_HERE"}}' --scope user
```

**Atlassian (Jira) MCP** -- lets Claude read/update tickets:

Run in your terminal:
```bash
claude mcp add --transport http --scope user atlassian https://mcp.atlassian.com/v1/mcp
```

When you first use it in Claude Code, a browser window opens for Atlassian OAuth. Log in with your account that has access to improvs.atlassian.net. If you don't have access, ask your manager to invite you at https://improvs.atlassian.net/people.

**Figma MCP** -- lets Claude read designs and verify UI implementation:

Run in your terminal:
```bash
claude plugin install figma@claude-plugins-official
```

After installing, authenticate inside Claude Code:
1. Open Claude Code in any project: `claude`
2. Type `/mcp`
3. Select `figma` > Authenticate
4. Log in with your Figma account in the browser

## What happens automatically (from the org)

Once you're in the org, these are deployed to your machine:

**Managed settings** (org-wide, you cannot override):
- Permission denies: `sudo`, `rm -rf`, reading `.env` / `.key` / `.pem` / `credentials` files
- Force push is blocked
- Bypass permissions mode is disabled

**Quality hooks** (fire on commit, branch creation, and file edit):
- Pre-commit checks run the project's stack-specific gates: `fvm flutter analyze + test` for Flutter, `dotnet build + test` for .NET, `ruff check + pytest` for Python
- Branch creation (`git checkout -b` / `git switch -c`) is blocked if the name doesn't contain a Jira key
- Auto-format on save: `dart format` for `.dart` files, `ruff format` for `.py` files

**Rules** (loaded based on project type):
- Global rules (git workflow, behavior, security)
- Flutter rules (if `pubspec.yaml` detected)
- .NET rules (if `.csproj` detected)
- Python rules (if `pyproject.toml` or `requirements.txt` detected)
- Docker rules (if `Dockerfile` detected)

**Skills** (available as /slash-commands):
- All [shared skills](skills.md) are provisioned via the org. Type `/` to see them.

## Verify your setup

Run this in any project directory:

```bash
claude
> What hooks and rules are active in this session?
```

Claude should list the quality hooks, rules loaded, and MCP servers available.

Check MCP connections:
```
/mcp
```

All three servers (github, atlassian, figma) should show as connected. If anything is missing, contact your manager.

## Project-level config

Each project also has its own `CLAUDE.md` in the repo root with:
- Project stack and commands
- Directory structure
- Project-specific conventions

This is loaded automatically when you open Claude Code in that directory.

## Related

- [Getting Started](getting-started.md) -- your first Claude Code session
- [Skills Reference](skills.md) -- all /slash-commands available after setup
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user features
