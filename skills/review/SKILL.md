---
description: Review only the changed Testo API integration code. Use for diff-based validation before merge or implementation handoff. Use when user says "review changes", "review code", "are the changes correct" or similar prompts.
user-invocable: true
---
Same as `/audit`. Review only the changed code paths related to Testo API integration. Report findings under `Testo integration issues`.
## Required steps
1. Refresh the relevant API docs with `/api-doc-update`.
2. Review the code paths that touch Testo API auth, requests, queue subscriptions, time windows, retries, and persistence.
3. Compare the implementation against the current API doc and rules.
4. Report actionable findings only; do not patch code.
5. Check rules items only; do not extend.
## Reference docs
- Data API: `../audit/references/data-api.md`
- Real-Time STOMP: `../audit/references/real-time-stomp.md`
## Output
```markdown
## Testo integration issues
- **Issue summary**
  - Why it matters
  - Recommended fix
```
## Scope
Review Testo API integration flow, data persistence, and config changes only. Ignore unrelated design, style, and general security issues. Route them to normal review pass.
