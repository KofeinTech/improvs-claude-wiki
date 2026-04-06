# Incident Response

What to do when something breaks in production.

## How we detect incidents

| Source | How it works |
|--------|-------------|
| Application logs | Monitored for errors and crashes |
| Client reports | Clients report issues in Telegram |
| QA testing | QA finds issues during testing cycles |
| App store reviews | Users report crashes or bugs |

## Severity levels

| Level | Description | Response time | Example |
|-------|-------------|---------------|---------|
| Critical | App is down or unusable for all users | Immediately | App crashes on launch, API returns 500 for all requests |
| High | Major feature broken, workaround exists | Within 2 hours | Login fails, payments broken, data loss |
| Medium | Feature partially broken, affects some users | Within 24 hours | UI glitch on specific devices, slow performance |
| Low | Minor issue, cosmetic | Next sprint | Wrong icon, alignment issue, typo |

## Response process

### 1. Acknowledge

When you discover or are told about an incident:
- Post in the project Telegram chat: what's broken, severity, who is looking at it
- Create a Jira bug ticket with steps to reproduce

### 2. Investigate

- Check application logs for errors
- Reproduce the issue locally if possible
- Identify the root cause before jumping to fix
- If it's a recent change, check the latest commits/merges

### 3. Fix

Use `/hotfix <JIRA-KEY>`. It branches from `main` (not `develop`), makes a minimum-viable fix with a regression test, runs all quality hooks, creates two PRs (one to `main`, one syncing back to `develop`), and updates Jira with PR links and time.

### 4. Deploy

- Get the `main` PR reviewed and merged ASAP (fast-track for critical/high severity)
- Deploy to production
- Verify the fix in production
- Notify the client that the issue is resolved
- Merge the `develop` sync PR after

### 5. Postmortem (for critical/high only)

After the fix is deployed, answer these in the Jira ticket:
- What broke?
- Why did it break?
- How did we detect it?
- How did we fix it?
- What will prevent this from happening again?

## Who to notify

| Severity | Notify |
|----------|--------|
| Critical | CEO + PM + all project developers immediately |
| High | PM + assigned developer |
| Medium | Assigned developer |
| Low | Add to backlog, assign in next sprint planning |
