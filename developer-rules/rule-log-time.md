# Rule: Log Time on Every Ticket

Log your actual time spent on each Jira ticket.

## Why

Time data is essential for: accurate future estimates, client billing, understanding team velocity, and identifying tasks that consistently take longer than expected. Without time logs, we're guessing on every estimate and every invoice.

## What to do

1. When you start a task, log the start time (use `/start` skill in Claude Code)
2. When you finish, log the end time (use `/finish` skill)
3. If you worked on multiple tickets in a day, log each one separately
4. Include actual time, not estimated time
5. If you spent 30 minutes investigating before realizing the task was wrong -- log that too

## Tips

- Use the `/start` and `/finish` Claude Code skills to automate Jira time logging
- If you forget to start the timer, estimate honestly and log it manually
- Round to the nearest 15 minutes
