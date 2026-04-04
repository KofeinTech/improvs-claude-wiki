# Rule: Small Tasks Only

Break every feature into tasks that take 1-4 hours each.

## Why

Large tasks lead to large PRs that nobody reviews properly. Small PRs get merged faster, have fewer bugs, and are easier to revert if something goes wrong. A 2,000-line PR gets a rubber stamp; a 200-line PR gets a real review.

## What to do

1. When you pick up a Jira ticket, check if it can be done in 1-4 hours
2. If not, break it into subtasks in Jira before starting
3. Each subtask gets its own branch and PR
4. Ship incrementally -- don't batch everything into one big PR

## Examples

- Bad: "Implement user authentication" (3 days)
- Good: "Add login API endpoint" (2h), "Add JWT token generation" (2h), "Add login screen UI" (3h), "Connect login screen to API" (2h)
