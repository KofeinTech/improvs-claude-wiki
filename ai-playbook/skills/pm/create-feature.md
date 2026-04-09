# /create-feature -- Create Feature Ticket

Guided creation of a well-structured Jira feature ticket. Claude asks clarifying questions, writes acceptance criteria, and creates the ticket in Jira.

## Usage

```
/create-feature <JIRA_PROJECT_KEY>
```

Example: `/create-feature PINK`

Valid project keys: FANT, PINK, CUE, REW, TRAD, SOL, IMP

## Who uses this

PMs, CEO, and developers who need to create a feature ticket in Jira.

## What happens when you run it

1. **Claude asks what you need**: "Describe the feature. What should the user be able to do?"
2. **Claude asks 2-4 clarifying questions** based on your description:
   - Scope (platforms, users)
   - UX details (confirmations, edge cases)
   - Dependencies (existing features, APIs)
   - Design (Figma needed or not)
3. **Claude generates a structured ticket** with:
   - Clear title (starts with a verb)
   - User story format (As a... I want to... so that...)
   - Testable acceptance criteria (3-7 items)
   - Technical notes
   - Out of Scope section (prevents scope creep)
4. **Shows you the ticket for review** -- you can adjust anything
5. **Creates in Jira** with priority and sprint/backlog placement

## Example session

```
> /create-feature PINK

Describe the feature. What should the user be able to do?
> Users should be able to share their profile via QR code

Does the QR code contain a deep link or just a URL?
> Deep link

Should it work offline (cached QR) or generate on demand?
> On demand is fine

Is there a Figma design for this?
> Not yet

FEATURE TICKET for PINK

Title: Add QR code profile sharing
Type: Story
Priority: Medium

As a user, I want to share my profile via QR code
so that other users can quickly view my profile.

## Acceptance Criteria
- [ ] User can generate QR code from profile screen
- [ ] QR code contains deep link to user profile
- [ ] QR code is shareable via system share sheet
- [ ] Scanning QR opens the app to that user's profile
- [ ] Works on both iOS and Android

## Technical Notes
UI changes required -- Figma design needed before implementation

## Out of Scope
- Custom QR code styling/branding
- QR code scanning within the app (use system camera)

Create this ticket in Jira?
> Yes, add to backlog

Created PINK-72: Add QR code profile sharing
```

## What Claude enforces

- Every acceptance criterion must be testable (QA can verify with yes/no)
- If there are more than 7 AC items, Claude suggests breaking it into multiple tickets
- If UI changes are involved, Claude notes "Figma design needed"
- "Out of Scope" section is always included to prevent scope creep
- No ticket is created without your confirmation

## Related

- [/create-bug](create-bug.md) -- for bug reports instead of features
- [/improvs:start](../workflow/start.md) -- what developers use when they pick up the ticket (Story or Bug, /improvs:start handles both)
