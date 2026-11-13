---
name: testo-real-time-api-review
description: Review Testo Real-Time API integration related code from changed code paths. Use for diff-based validation before merge or implementation handoff. Use when user says "review changes", "review code", "are the changes correct" or similar prompts. Also trigger with `/testo-real-time-api-review`.
user-invocable: true
---
Review the changed code paths related to Testo Real-Time API integration; follow the steps below strictly and thoroughly.
## Required steps
1. Refresh and get the latest Testo Real-Time API reference docs with skill `/testo-real-time-api-doc`.
2. Get the full list of Testo Real-Time API integration rules with skill `/testo-real-time-api-rules`.
3. Review the code paths related to Testo Real-Time API integration based on the latest API reference docs and integration rules.
4. Report issues found only; do not patch code.
## Output
If issues are found, report them as follows:
```markdown
## Testo Real-Time API integration issues
- **Rule violated**
  - Code file and line number where the issue is found
  - Recommended fix
```
## Scope
Review Testo Real-Time API integration flow, data persistence, and configuration changes only. Unrelated design, coding style, and general security issues should be routed to the normal review pass.
