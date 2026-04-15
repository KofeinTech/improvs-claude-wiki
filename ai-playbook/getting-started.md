# Getting Started with Claude Code

Claude Code is an AI coding assistant that runs in your terminal. It reads your codebase, writes code, runs tests, and creates commits -- all through natural language conversation.

## Step 0: Set up your machine

Before anything else, run the setup script. It installs Claude Code, connects Jira, GitHub, and Figma, and logs you into the Improvs organization.

```bash
# Download and run the setup script
curl -sO https://raw.githubusercontent.com/KofeinTech/improvs-claude-wiki/main/setup-developer.sh
chmod +x setup-developer.sh
./setup-developer.sh
```

The script installs Node.js, Claude Code CLI, GitHub CLI (`gh`), logs you into both the Claude org and GitHub, and installs the Improvs and Superpowers plugins. GitHub access uses `gh` CLI directly. Atlassian MCP uses browser OAuth on first use.

If you prefer to set up manually, see the [Setup Guide](claude-code-setup.md) for step-by-step instructions.

## Why we use it

Improvs is an AI-first company. Every task starts with AI. Manual coding is the fallback, not the default. Claude Code is our primary development tool because it understands the full project context, follows our coding standards automatically, blocks bad code before it reaches the repo, and standardizes our common workflows across every project.

## What Claude Code knows about your project

When you start Claude Code in a project directory, several layers of context load automatically. This is what makes it different from a generic AI tool:

| Layer | What it gives Claude |
|---|---|
| **Project files** | Read access to every file in the working directory. Claude can navigate the codebase, find functions, understand how modules connect. |
| **CLAUDE.md** | Project-specific instructions: tech stack, run/test/lint commands, base branch, conventions. Every Improvs project has one. |
| **`.claude/rules/`** | Org-deployed coding rules for your stack (Flutter / .NET / Python / Docker). Loaded automatically -- no setup needed. |
| **MCP servers** | Live connections to external systems: **Jira** (read/update tickets via Atlassian MCP), **Figma** (read designs and tokens). **GitHub** access uses `gh` CLI directly. Set up by `setup-developer.sh`. |
| **Org-wide rules** | Improvs global rules (git workflow, security, behavior) deployed via Claude Organization settings. Loaded into every session. |
| **Hooks** | Background safety checks that intercept dangerous commands and run quality gates before commits. |

Together this means Claude isn't just "an AI in your terminal" -- it has the real-time state of your Jira board, your project's rules, and the conventions every developer at Improvs follows. That's why every task starts with `/improvs:start <JIRA-KEY>` (see below) -- the skill picks up all of this context automatically and routes the work without you having to brief Claude on any of it.

## Your first task end-to-end

Every Improvs task starts with a Jira ticket and ends with a PR linked back to that ticket. The `/improvs:start` and `/improvs:finish` skills handle everything in between -- branch naming, time tracking, PR creation, Jira status updates.

A typical session:

**1. Open Claude Code in the project**

```bash
cd ~/code/your-project
claude
```

**2. Run `/improvs:start <JIRA-KEY>`**

```
> /improvs:start PROJ-42
```

Claude reads the Jira ticket via the Jira MCP, checks the type and acceptance criteria, classifies the task complexity (trivial / simple / complex), creates a branch named `PROJ-42-<short-description>`, moves the ticket to "In Progress", and shows you a `READY TO START` block with the classification.

For non-trivial tasks, `/improvs:start` then automatically invokes the **superpowers** plugin -- TDD discipline for simple tasks, brainstorming + plan + execute for complex ones. See [Superpowers](superpowers.md) for what this looks like and what to expect.

**3. Review and code with Claude**

Claude reads the relevant files, proposes changes, and writes code. You see every file as it is edited. **Read every diff before letting Claude continue.** When Claude is wrong, push back -- *"no, use the existing service instead of creating a new one"*. When Claude asks a clarifying question, answer it -- the more context you give, the better the result.

**4. Commit yourself**

Claude never auto-commits. When the changes look right, you commit them. The pre-commit hooks run analyze + tests automatically -- if anything fails, fix it and commit again.

**5. Run `/improvs:finish`**

```
> /improvs:finish
```

`/improvs:finish` runs `/improvs:review` (which checks the diff against the Jira AC and hard-blocks any hardcoded secrets), runs `/improvs:test` (independent test generation if no test files were added), pushes the branch, creates the PR with a Jira link and AC checklist, moves the ticket to "In Review", and logs your time on the ticket.

If review finds issues or tests fail, `/improvs:finish` stops and tells you what to fix. After fixing, re-run `/improvs:finish`.

## Key principles

**AI drafts, you decide.** Claude generates code. You validate business logic, check edge cases, and take responsibility for what gets committed.

**Small tasks only.** Break work into 1-4 hour pieces. One Jira ticket = one branch = one PR. Each task gets its own Claude Code session.

**Never trust blindly.** AI generates plausible-looking code that may be wrong. Always read the diff. Check business logic, security implications, and test coverage.

## Next steps

- Read the [Superpowers guide](superpowers.md) -- understand what `/improvs:start` invokes for non-trivial tasks
- Learn [best practices](best-practices.md) for effective prompting
- Browse the [prompt library](prompt-library.md) for ready-to-use prompts
- Check the [skills reference](skills.md) for all available /slash-commands
- Read the [developer rules](../developer-rules/) for commit and review standards

## Related

- [Setup Guide](claude-code-setup.md) -- detailed manual setup and MCP configuration
- [Best Practices](best-practices.md) -- how to prompt effectively
- [Skills Reference](skills.md) -- all available /slash-commands
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user tips
