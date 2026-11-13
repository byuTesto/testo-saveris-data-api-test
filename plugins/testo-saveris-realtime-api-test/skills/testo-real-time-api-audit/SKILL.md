---
name: testo-real-time-api-audit
description: Same as review, but for the entire repository to report Testo Real-Time API integration issues. Use when user says "review the codebase", "validate the integration", "check the integration" or similar prompts. Also trigger with `/testo-real-time-api-audit`.
user-invocable: true
---
Do the same as `/testo-real-time-api-review`, but for the entire repository instead of only the changed (diff) paths.

## Output format
If issues are found, report them as follows:
```markdown
## Testo Real-Time API integration issues
- **Issue summary**
  - Why it is a problem
  - Recommended fix
```
## Scope
Review only Testo Real-Time API integration flow, data persistence, and config changes. Unrelated design, coding style, and general security issues should be routed to the normal review pass.