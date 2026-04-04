# Rule: Separate Claude Contexts

Each task should start in a fresh Claude Code session. Do not carry context from one task to another.

## Why

Claude Code carries the entire conversation history in its context window. If you switch tasks mid-session, Claude still has the old task in memory -- it can mix up variable names, file paths, architecture decisions, and requirements between the two tasks. Fresh context = clear thinking.

## What to do

1. Finish your current task (commit, PR, done)
2. Start a new Claude Code session (new terminal tab or restart)
3. Begin the new task with a clean context
4. Reference the Jira ticket so Claude has the right requirements

## When it's OK to continue a session

- You're doing a follow-up fix on the same PR
- You need to continue debugging the same issue
- The tasks are tightly related subtasks of the same feature
