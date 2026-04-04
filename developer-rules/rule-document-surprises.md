# Rule: Document Surprises

If you discover something non-obvious about a project, write it down where others can find it.

## Why

Knowledge that lives only in your head helps nobody. The next developer (or future you) will waste hours rediscovering the same workaround, API quirk, or deployment gotcha. Writing it down once saves the entire team time forever.

## What counts as a surprise

- A workaround for a library bug
- An API that behaves differently than documented
- A deployment step that isn't automated yet
- A config setting that must be a specific value for non-obvious reasons
- A test that requires specific setup (database state, environment variables)
- Anything that made you say "I wish I knew this 2 hours ago"

## Where to document it

- **Project-specific:** add to the project's `CLAUDE.md` (so Claude Code also learns it)
- **Cross-project:** add to the wiki under the relevant section
- **Temporary workaround:** add a Jira ticket for the proper fix, document the workaround in the ticket
