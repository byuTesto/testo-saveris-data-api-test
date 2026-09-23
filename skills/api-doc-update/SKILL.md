---
name: api-doc-update
description: Refresh Testo Data API and Real-Time API reference docs.
user-invocable: true
---
Refresh the relevant API reference files. Use the root-level `scripts/` entrypoints to perform the download and rename flow.
## Scripts
- Shell: `scripts/update-api-docs.sh [all|data|real-time]`
- PowerShell: `scripts/update-api-docs.ps1 -Target <all|data|real-time>`
- Batch: `scripts/update-api-docs.bat [all|data|real-time]`
## Download rules
- Save docs only with a date suffix: `YYYY-MM-DD`.
- Keep only the latest downloaded version for each doc.
- Delete undated legacy files and older dated versions.
- Skip the download when today's dated file already exists.
## Scope
Refresh only the API docs needed for the current task. Do not refresh unrelated docs.