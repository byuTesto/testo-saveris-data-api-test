---
name: testo-data-api-audit
description: Same as review, but for the entire repository to report Testo Data API integration issues. Use when user says "review the codebase", "validate the integration", "check the integration" or similar prompts. Also trigger with `/testo-data-api-audit`.
user-invocable: true
---
Do the same as `/testo-data-api-review`, but for the entire repository instead of only the changed (diff) paths.
## Output format
If issues are found, report them as follows:
```markdown
## Testo Data API integration issues
- **Issue summary**
  - Why it is a problem
  - Recommended fix
```
## Scope
Review only Testo Data API integration flow, data persistence, and configuration changes. Unrelated design, coding style, and general security issues should be routed to the normal review pass.