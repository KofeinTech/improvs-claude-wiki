# Security Guidelines

## Secrets Management

- **Never** commit API keys, credentials, .env files, signing certificates, or passwords to any repository
- All secrets go to **GitHub Actions secrets** (per-repo) -- not on developer machines
- Claude Code is configured to block reading `.env*`, `*.key`, `*.pem`, `credentials*` files
- If you accidentally commit a secret: rotate it immediately, then remove from git history

## App Store Access

- Only CEO + designated backup have production deploy keys for Apple Developer and Google Play Console
- Developers do not deploy to app stores directly
- Merging to `main` triggers automated CI/CD build and release
- Signing certificates are stored in GitHub Actions secrets, not on local machines

## Code Security

- Run `/security` skill before submitting PRs that touch authentication, payments, or user data
- Never disable SSL verification, even in development
- Never hardcode URLs, tokens, or environment-specific values -- use config/constants
- Dependencies: review new packages before adding. Prefer well-maintained libraries with active security updates

## Communication Security

- Do not share credentials via Telegram, email, or chat
- Use GitHub Actions secrets or a secure vault for all credentials
- Client NDA information stays in project-specific channels, not general chat
