---
description: Audit the repository for Testo API integration issues. Use when user says "review the codebase", "validate the integration", "confirm whether current integration is correct" or similar prompts.
user-invocable: true
---
Review the repo for integration issues and report them under a `Testo integration issues` section.

## Required steps
1. Refresh the relevant API docs with `/api-doc-update`.
2. Review the code paths that touch Testo API auth, requests, queue subscriptions, time windows, retries, and persistence.
3. Compare the implementation against the current API doc and rules.
4. Report actionable findings only; do not patch code.
5. Check rules items only; do not extend.
## Reference docs
- Data API: `./references/data-api.md`
- Real-Time STOMP: `./references/real-time-stomp.md`
## Output format
```markdown
## Testo integration issues
- **Issue summary**
  - Why it is a problem
  - Recommended fix
```
## Scope
Review only Testo API integration flow, data persistence, and config changes. Ignore unrelated design, style, and general security issues. Route them to normal review pass.