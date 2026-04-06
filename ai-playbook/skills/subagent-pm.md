# PM Subagent

A project management context agent that answers questions about current project status, sprint, tickets, blockers, team, and deadlines. Reads live Jira data.

## How it's used

The PM subagent is invoked automatically when you ask Claude project-related questions. You don't call it directly -- Claude routes to it when appropriate.

## What it can answer

- "What's the current sprint status?"
- "Who's working on what?"
- "Are there any blockers?"
- "What's the deadline for this milestone?"
- "How many tickets are in review?"
- "What did we ship last week?"

## How it works

1. Detects the current project from your branch or CLAUDE.md
2. Reads project info and sprint data from Jira
3. Provides factual answers -- does NOT make decisions
4. If a question requires a decision, directs you to your PM or tech lead

## Model

Runs on Sonnet (faster, cheaper) since it's answering factual questions from Jira data, not writing code.

## Related

- [/onboard](onboard.md) -- full project briefing for new members
- [/client-report](client-report.md) -- formatted report for clients
