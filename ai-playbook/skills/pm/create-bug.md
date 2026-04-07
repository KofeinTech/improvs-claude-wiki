# /create-bug -- Create Bug Report

Structured bug report creation in Jira. Claude asks for reproduction steps, environment, and severity, then creates a properly formatted bug ticket.

## Usage

```
/create-bug <JIRA_PROJECT_KEY>
```

Example: `/create-bug PINK`

Valid project keys: FANT, PINK, CUE, REW, TRAD, SOL, IMP

## Who uses this

PMs, CEO, and developers who found a bug that needs a Jira ticket.

## What happens when you run it

1. **Claude asks what's broken**: "Describe the bug. What's happening that shouldn't be?"
2. **Claude asks for missing details** (only what you didn't already provide):
   - How to reproduce -- step by step
   - What should happen instead
   - Platform and version
   - How often it happens
3. **Claude generates a structured bug ticket** with:
   - Descriptive title (symptom + context)
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details
   - Frequency
   - Auto-suggested priority based on severity
4. **Shows you the ticket for review** -- you can adjust anything
5. **Creates in Jira** with priority and labels

## Auto-priority logic

Claude suggests priority based on what the bug does:

| Severity | Priority | Examples |
|----------|----------|----------|
| App crash, data loss, security issue | Critical | "App crashes on login" |
| Feature broken, workaround exists | High | "Can't upload photos but can use camera" |
| UI glitch, minor issue | Medium | "Button misaligned on small screens" |
| Cosmetic, typo, edge case | Low | "Typo in settings label" |

You can always override the suggestion.

## Example session

```
> /create-bug PINK

Describe the bug. What's happening that shouldn't be?
> App crashes when user taps notifications on Android 14

How do you reproduce this? Step by step.
> 1. Get a push notification  2. Tap it  3. App crashes

Which app version?
> 2.3.1

BUG TICKET for PINK

Title: App crashes on notification tap (Android 14)
Type: Bug
Priority: Critical (crash affecting user flow)

## Steps to Reproduce
1. Receive a push notification
2. Tap the notification
3. App crashes instead of opening

## Expected Behavior
App opens to the relevant screen

## Actual Behavior
App crashes immediately

## Environment
- Platform: Android
- OS Version: Android 14
- App Version: 2.3.1

## Frequency
Every time

Create this ticket in Jira?
> Yes, add to current sprint

Created PINK-73: App crashes on notification tap (Android 14)
Critical bug -- added to current sprint
```

## What Claude enforces

- Every bug must have reproduction steps. If unknown, marked as "needs investigation"
- Every bug must have expected vs actual behavior
- If you report multiple bugs at once, Claude asks to create separate tickets
- No technical speculation about root cause -- that's the developer's job during `/start` (which runs a bug investigation step automatically when the ticket type is Bug)
- Language is neutral and factual

## Related

- [/create-feature](create-feature.md) -- for features instead of bugs
- [/start](../workflow/start.md) -- what developers use to fix this bug (auto-investigates bugs, auto-detects hotfixes)
