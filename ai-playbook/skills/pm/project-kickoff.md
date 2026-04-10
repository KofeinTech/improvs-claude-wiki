# /project-kickoff -- New Project Setup

Full project kickoff in one session. Reads Figma, drafts the Jira project description and 5-10 Epics, creates everything in Jira. For PMs starting a new client project.

## Usage

```
/project-kickoff <JIRA_PROJECT_KEY>
```

Example: `/project-kickoff REST`

## Prerequisites

Before running this skill, you need:
- Jira project already created (Kanban board, columns configured, fields enabled -- see [New Project Setup](../../../processes/jira-workflow.md#new-project-setup-adminlead))
- Figma URL from client/designer
- Product spec (what the app does, MVP scope)
- Client info (company, contact, channel)
- Repo URLs (from CEO)
- Team list (PM + developers, from CEO)

## Who uses this

PM (Darya) when a new project lands.

## What happens when you run it

1. **Collects inputs** -- Figma URL, product spec, client info, repos, team, stack, deadlines
2. **Reads Figma via MCP** -- identifies screens, flows, feature areas, navigation structure
3. **Drafts project description** -- client, repos, links, team, deadlines (using the standard Improvs template). This is the operational info that `/improvs:onboard`, `/client-report`, and the PM subagent read.
4. **Drafts 5-10 Epics** -- each with What/Why/Acceptance Criteria (high-level)/Scope/Out of scope
5. **Suggests execution order** -- which Epic first and why
6. **PM reviews and adjusts** -- merge/split Epics, change priorities, edit scope
7. **Creates in Jira** -- updates project description + creates all Epics in Backlog
8. **Prints next steps** -- how to break down the first Epic into Tasks

## Example output

```
KICKOFF COMPLETE
================
Project:     Restaurant Onboarding (REST)
Client:      ExampleCorp
Stack:       Flutter
Team:        Darya (PM) + Bogdan, Volodymyr

Created:
  Project description -- updated in Jira
  7 Epics in Backlog:
    REST-1  Authentication system
    REST-2  Onboarding flow
    REST-3  Video library
    REST-4  Quiz system
    REST-5  Profile & settings
    REST-6  Push notifications
    REST-7  Infrastructure & CI/CD

Next steps:
  1. Run: /create-feature REST breakdown Authentication system
  2. Move ready Tasks to To Do, assign developers
  3. Developers run /improvs:start <TASK-KEY>
```

## What this skill does NOT do

- **Does not create Tasks.** Only Epics. Tasks are drafted later via `/create-feature REST breakdown <Epic>` when the team is ready to start each Epic (progressive elaboration).
- **Does not set up the Jira project.** Board columns, fields, automation rules, GitHub integration must be configured before running this skill.
- **Does not assign developers to Epics.** PM assigns developers to Tasks, not Epics.

## Related

- [New Project Setup guide](../../../processes/new-project-setup.md) -- the full kickoff process (this skill automates Steps 2-4)
- [/create-feature](create-feature.md) -- create individual Tasks or break down Epics into Tasks
- [Jira Workflow: Project Setup](../../../processes/jira-workflow.md#new-project-setup-adminlead) -- how to configure a new Jira project
- [Ticket Templates](../../../processes/ticket-templates.md) -- Epic and Task templates this skill uses
