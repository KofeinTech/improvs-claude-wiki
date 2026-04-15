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
2. Installs Claude Code CLI and logs you into the Improvs Claude organization
3. Checks your Atlassian account access
4. Adds GitHub MCP server entry to your config (placeholder -- activate after setup)
5. Adds Atlassian MCP server entry to your config (browser OAuth on first use)
6. Installs the Superpowers plugin
7. Verifies all MCP entries are present in config

**After the script finishes**, activate each MCP server following the instructions below.

Works on macOS, Linux, and Windows (WSL). No browser windows are opened during setup -- all steps are done in the terminal.

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

### 3. Activate MCP servers

The setup script adds MCP server entries to `~/.claude.json` automatically. After the script runs, you need to activate each one with your credentials.

All commands below are run in your **regular terminal** (not inside a Claude Code session).

---

#### Activate GitHub MCP

GitHub MCP lets Claude read repos, create PRs, and manage issues.

**Step 1 -- Create a Personal Access Token:**

1. Go to: `https://github.com/settings/tokens/new`
   (GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic))
2. Fill in:
   - Note: `Claude Code MCP`
   - Expiration: 90 days (recommended)
3. Select these scopes:
   - `[x] repo` -- full access to private repos
   - `[x] read:org` -- read org membership
   - `[x] read:user` -- read profile data
4. Click **Generate token** and copy it immediately (starts with `ghp_`)

Quick link with scopes pre-filled:
`https://github.com/settings/tokens/new?scopes=repo,read:org,read:user&description=Claude+Code+MCP`

**Step 2 -- Add token to your config:**

```bash
# Replace YOUR_GITHUB_PAT with the token you just created
jq --arg t "Bearer YOUR_GITHUB_PAT" \
  '.mcpServers.github.headers.Authorization = $t' \
  ~/.claude.json > /tmp/claude.json && mv /tmp/claude.json ~/.claude.json
```

Or run in terminal:
```bash
claude mcp add-json github \
  '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}' \
  --scope user
```

**Step 3 -- Verify:**
Open Claude Code and run `/mcp` -- `github` should show as **connected**.

---

#### Activate Atlassian MCP

Atlassian MCP lets Claude read and update Jira tickets.

Uses the official Atlassian MCP server (`mcp.atlassian.com`) with browser-based OAuth. No token needed -- authentication happens automatically when Claude first uses Jira.

**Step 1 -- Make sure you have access:**

If you don't have access to `improvs.atlassian.net`, ask your manager to invite you at:
`https://improvs.atlassian.net/people`

**Step 2 -- Trigger authentication:**

Open Claude Code in any project and run:
```
/mcp
```

The `atlassian` server will show as **needs authorization**. Click the authorization link -- a browser window opens. Log in with your `improvs.atlassian.net` account and authorize.

After authorizing, run `/mcp` again -- `atlassian` should show as **connected**.

That's it. No tokens or config changes needed.

**Figma API key** -- lets Claude export and read Figma designs via REST API:

The team uses a shared Figma Personal Access Token from a designer who already has a Full seat. No extra cost per developer.

1. Ask your lead for the shared `FIGMA_API_KEY` for your project
2. Add it to your shell profile:
```bash
echo 'export FIGMA_API_KEY=figd_xxxxx' >> ~/.zshrc
source ~/.zshrc
```
3. Test it works by running in Claude Code:
```
/improvs:figma-export https://www.figma.com/design/YOUR_PROJECT_FILE?node-id=1:2
```

This exports the design to local `design/` folder as JSON + SVG assets. All other skills (`/improvs:start`, `/improvs:figma-check`) read from these local files automatically.

### 4. Verify MCP connections

After setting up all three servers, open Claude Code and run:

```
/mcp
```

Both servers (github, atlassian) should show as **connected** with a green status. If any server shows as disconnected or missing, re-run the setup step for that server.

Figma uses `FIGMA_API_KEY` env var (provided by your lead). Verify it works by running `/improvs:figma-export` with any Figma URL.

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
- Developer skills are delivered via the `improvs` plugin (auto-installed). Type `/improvs:` to see them.
- PM/CEO skills are available on claude.ai web (Organization Skills).
- See the [skills reference](skills.md) for the full list.

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

Both servers (github, atlassian) should show as connected. Figma uses `FIGMA_API_KEY` env var -- verify with `/improvs:figma-export`. If anything is missing, contact your manager.

## Project-level config (CLAUDE.md)

Every Improvs project must have a `CLAUDE.md` file in the repo root. Claude Code reads it automatically when you open a project directory. Without it, skills like /improvs:start, /improvs:review, and /improvs:finish may not detect the correct base branch or stack.

**What CLAUDE.md contains:**
- Project name and Jira key
- Tech stack and framework versions
- Run, test, lint, and format commands
- Base branch (usually `develop`)
- Directory structure overview
- Project-specific conventions

**Templates for new projects:**

| Stack | Template repo | What's included |
|-------|--------------|-----------------|
| Flutter | `improvs/flutter-template` | FVM, Riverpod, GoRouter, Freezed, Dio |
| .NET | `improvs/dotnet-template` | ASP.NET Core, EF Core, MediatR, xUnit |
| Python | `improvs/python-template` | FastAPI, SQLAlchemy, Pydantic, pytest, Ruff |

When creating a new project, copy the CLAUDE.md from the matching template repo and fill in the project-specific values (name, Jira key, any custom conventions).

**For existing projects missing CLAUDE.md:** create one from the closest template. At minimum include: project name, stack, run/test/lint commands, Jira key, and base branch.

## Troubleshooting

### Skills not showing up

If `/improvs:` doesn't list skills (like /improvs:start, /improvs:finish, /improvs:review):

1. Check the plugin is installed: `claude plugin list` -- look for `improvs@improvs-marketplace`
2. If missing, update marketplace: run `/plugin marketplace update` inside Claude Code
3. Re-login to the org: `claude logout && claude login`
4. Update the CLI: `npm update -g @anthropic-ai/claude-code`
5. Restart Claude Code

### MCP server not connecting

If `/mcp` shows a server as disconnected or a skill says "Jira MCP failed":

1. Open `/mcp` in Claude Code and re-authenticate the failing server
2. For GitHub: your Personal Access Token may have expired -- generate a new one at
   `https://github.com/settings/tokens/new?scopes=repo,read:org,read:user&description=Claude+Code+MCP`
   and re-add it (see "Activate GitHub MCP" above)
3. For Atlassian: re-run the browser OAuth flow:
   ```
   /mcp
   ```
   Click the authorization link next to the `atlassian` server and log in again.
4. For Figma: uses `FIGMA_API_KEY` env var. Check:
   - `echo $FIGMA_API_KEY` -- should print the token
   - If empty, ask your lead for the shared key and add to `~/.zshrc`
   - If set but exports fail with 403, the token may have expired -- ask the designer to regenerate

### Hooks not firing

If pre-commit checks or branch validation aren't running:

1. Ask Claude: "What hooks and rules are active in this session?"
2. If none listed, managed settings may not be deployed -- contact your manager
3. Restart Claude Code (hooks load on startup)

### Superpowers plugin issues

If /review reports that superpowers is unavailable:

1. Check if installed: `claude plugin list`
2. Reinstall manually: `claude plugin install superpowers@superpowers-marketplace`
3. Note: /review has an inline fallback and will still produce a structured review without superpowers

### Common errors

| Error | Cause | Fix |
|-------|-------|-----|
| "Branch must follow JIRA-KEY-description" | Branch name missing Jira key | Use format: `PINK-42-add-feature` |
| "flutter analyze must pass" | Dart analysis errors | Fix the errors shown, then re-commit |
| "Force push is not allowed" | Hook blocks `git push --force` | Use regular push. If needed, ask a lead for `--force-with-lease` approval |
| "Branch has no Jira key" | /review can't extract ticket key | Rename branch to include the key: `git branch -m PINK-42-description` |
| "Cannot /review from main" | Running /review on a protected branch | Switch to your feature branch first |

## Related

- [Getting Started](getting-started.md) -- your first Claude Code session
- [Skills Reference](skills.md) -- all /slash-commands available after setup
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user features
