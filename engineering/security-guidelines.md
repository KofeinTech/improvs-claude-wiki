# Security Guidelines

## Secrets Management

- **Never** commit API keys, credentials, .env files, signing certificates, or passwords to any repository
- All secrets go to **GitHub Actions secrets** (per-repo) -- not on developer machines
- Claude Code is configured to block reading `.env*`, `*.key`, `*.pem`, `*.p12`, `*.jks`, `**/credentials*`, `**/secrets*`, `**/service-account*.json` files

## OWASP awareness

Keep these top OWASP risks in mind on every PR that touches user input, auth, or data:

1. **Injection** -- always use parameterized queries; never concatenate user input into SQL, shell commands, or HTML
2. **Broken authentication** -- bcrypt or argon2 for password hashing, enforce token expiry, never roll your own crypto
3. **Sensitive data exposure** -- never log passwords, tokens, or PII; never return full error stacks to clients
4. **Input validation** -- validate every input at the boundary using the project's typed validation layer (Pydantic for FastAPI, FluentValidation for .NET, Freezed for Flutter models)
5. **Security logging** -- log security-relevant events (login attempts, permission changes, privileged data access)

## .gitignore requirements

Every repo must include these patterns in `.gitignore`:

```
.env
.env.*
*.key
*.pem
*.p12
*.jks
**/credentials*
**/secrets*
**/service-account*.json
*.keystore
local.properties
```

If you create a new repo, copy this list into the `.gitignore` before the first commit. Hooks block reading these files at runtime, but `.gitignore` is what stops them from ever being committed by accident.

## Security incident response

If a secret is accidentally committed or any vulnerability is found:

1. **Do NOT push fixes publicly until the vulnerability is understood.** A naive "fix" can advertise the issue or leave it half-patched.
2. **Rotate exposed credentials FIRST**, before investigating or fixing. The old value is compromised even after a `git revert` -- assume it is already harvested.
3. **Create a Jira ticket** in the IMP project with label `security`, assign to CEO. Track the issue, root cause, and fix in the ticket.
4. **Document the issue, root cause, and fix** in the ticket once resolved.

## App Store Access

- Only CEO + designated backup have production deploy keys for Apple Developer and Google Play Console
- Developers do not deploy to app stores directly
- Merging to `main` triggers automated CI/CD build and release
- Signing certificates are stored in GitHub Actions secrets, not on local machines

## Code Security

- Run `/improvs:review` before any commit that touches authentication, payments, or user data -- it hard-blocks hardcoded secrets, checks the diff against project rules, and verifies acceptance criteria are addressed
- Never disable SSL verification, even in development
- Never hardcode URLs, tokens, or environment-specific values -- use config/constants
- Dependencies: review new packages before adding. Prefer well-maintained libraries with active security updates

## Communication Security

- Do not share credentials via Telegram, email, or chat
- Use GitHub Actions secrets or a secure vault for all credentials
- Client NDA information stays in project-specific channels, not general chat
