# Tips and Tricks

Practical tips to get more out of Claude Code. These go beyond the basics in [Best Practices](best-practices.md).

## Plan mode

Plan mode makes Claude think through the approach before writing code. It reads files, explores the codebase, and presents a step-by-step plan for your approval.

**When to use it:**
- Complex tasks (multiple files, multiple layers)
- You're not sure what the right approach is
- New feature that needs architectural decisions
- Refactoring that could break things

**How to use it:**
- Type `Shift+Tab` to switch to plan mode (or `/plan`)
- Describe the task
- Claude explores and presents a plan
- Review the plan, ask questions, adjust
- Press `Shift+Tab` again to switch back to code mode and implement

**Pro tip:** You can go back and forth. Start in plan mode, approve the plan, switch to code mode for implementation. If something unexpected comes up, switch back to plan mode to re-think.

## Permissions

Claude Code asks for permission before running commands, editing files, etc. Here's how to manage this efficiently.

**Auto-accept for a session:**
- Press `Shift+Enter` to accept and allow similar actions for the rest of the session
- This saves you from approving every file edit one by one

**Bypass for trusted operations:**
- Type `!` before a command to run it directly in your terminal without Claude's involvement
- Example: `! flutter pub get` -- runs immediately, output goes into the conversation

**Permission modes:**
- Default mode asks before each action
- You can set more permissive modes in settings, but the org enforces security rules that cannot be bypassed (force push blocked, secrets reading blocked, sudo blocked)

## Context management

Claude Code has a context window. When it fills up, older messages get compressed. Tips to manage this:

- **One task per session.** Start fresh for each Jira ticket.
- **Use `/compact`** when a session gets long. It summarizes the conversation without losing important context.
- **Use `/clear`** to start completely fresh within the same session.
- **Point to files directly.** Instead of pasting code, say "read lib/features/auth/auth_provider.dart" -- Claude reads it with full context.

## What Claude Code can do (that you might not know)

**Read images and screenshots:**
- Paste a screenshot into the conversation
- Claude can analyze UI screenshots, error dialogs, terminal output
- Useful for bug reports: "Here's what the screen looks like, it should look like the Figma design"

**Read PDFs:**
- Claude can read PDF files directly
- Useful for specs, API documentation, design briefs

**Run in background:**
- Claude can run long commands in the background while continuing to work
- Example: run tests in background, keep coding, get notified when tests finish

**MCP integration:**
- `/mcp` shows all connected servers and their status
- Jira, GitHub, Figma are all accessible directly from Claude Code
- No need to switch to browser for Jira ticket details or Figma specs

**Multiple tool calls:**
- Claude can read multiple files, run multiple searches, and make multiple edits in a single response
- This makes it fast for tasks that touch many files

## Working with skills

- Type `/` to see all available skills
- Skills accept arguments: `/improvs:start PINK-42`, `/improvs:review 47`
- Skills chain together: `/improvs:start` -> code -> `/improvs:finish`
- For production emergencies, `/improvs:start` auto-detects Critical priority and branches from main
- If a skill asks you a question, be specific. "I don't know" is better than a vague answer.
- See [Skills Reference](skills.md) for the full list

## Efficient prompting

**Be lazy -- give less, not more:**
- "fix the failing test" (if there's only one failing test, Claude will find it)
- You don't need to explain what's obvious from the code

**Use references:**
- "do it like auth_provider.dart" (Claude reads the file and follows the pattern)
- "same structure as the profile feature" (Claude copies the directory layout)

**Interrupt early:**
- If Claude starts going the wrong direction, say "stop" or press Escape
- Correct the approach before it writes more code
- Cheaper to restart than to fix

**Stack commands:**
- "read the Jira ticket, check the Figma design, then create a plan" (Claude does all three)

## Related

- [Best Practices](best-practices.md) -- foundational guidance for working with Claude Code
- [Skills Reference](skills.md) -- all /slash-commands
- [Prompt Library](prompt-library.md) -- ready-to-use prompts for common tasks
