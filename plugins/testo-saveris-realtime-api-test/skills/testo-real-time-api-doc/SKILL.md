---
name: testo-real-time-api-doc
description: Refresh and provide the latest Testo Real-Time API reference docs. Use when the user says things like 'show Testo Real-Time Socket/STOMP API document', 'update Testo Real-Time API docs', 'document to subscribe to alarm queue' or similar queries. Also use when invoked via /testo-real-time-api-doc directly.
user-invocable: true
---

Refresh the Testo Real-Time API reference files. Use the skill-local `scripts/` entrypoints (paths relative to this skill directory) to perform the download and rename flow.

## Scripts
- Shell: `scripts/update-api-docs.sh`
- PowerShell: `scripts/update-api-docs.ps1`
- Batch: `scripts/update-api-docs.bat`

## References
Documents are written to this skill's `references/` folder:
- `async-api-YYYY-MM-DD.yaml`: Real-Time STOMP API
- `openapi-YYYY-MM-DD.yaml`: version settings REST API

## Output
Provide the API document in a human-readable format instead of raw YAML or JSON. Note to mark deprecated endpoints and queues clearly. By default, provide the entire reference content for STOMP API only. But if specific STOMP queues/channels or REST endpoints are requested, provide only related sections and references.
