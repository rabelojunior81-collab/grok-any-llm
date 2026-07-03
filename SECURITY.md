# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 0.0.x   | ✅ security fixes  |
| < 0.0.1 | ❌ not supported   |

## Reporting a Vulnerability

**Do NOT open a public issue for security vulnerabilities.**

Report privately to **rabelo.work@gmail.com** with:
- Description of the issue and potential impact.
- Steps to reproduce (PoC if possible).
- Affected version/file.

### Response SLA
- **Acknowledgment:** within 48 hours.
- **Initial assessment:** within 5 business days.
- **Fix or mitigation:** coordinated disclosure after a fix is available (typically within 30 days; critical sooner).

Please do not disclose the vulnerability publicly until a fix is released and we've coordinated a disclosure date. We credit reporters in the release notes (unless you prefer to remain anonymous).

## Scope

This policy covers the `grok-any-llm` (`gall`) codebase. Note: `gall` **never stores API keys** in the repo or in profile configs — keys live in user-scoped environment variables, referenced via `env_key`. The `grok` binary and upstream providers (OpenRouter, Kilo, OpenCode Go) have their own security policies.

## Security Measures in This Project
- Keys only in env vars (never committed). `.gitignore` guards secrets.
- Profiles use `env_key`, never hardcoded `api_key`.
- CI runs **GitHub CodeQL** analysis on every PR.
- Branch protection + required checks on `main`.
- Honest archeology of any security incident in `.archeology/` (blameless postmortem).
