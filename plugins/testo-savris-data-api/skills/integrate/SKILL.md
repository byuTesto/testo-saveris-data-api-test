---
name: integrate
description: Integrate Testo Data API family safely and correctly. Use for Testo device, sensor, alarm, measurement, task, and queue integration and issue fix work. Do not use for unrelated APIs.
user-invocable: true
---
# Integrate
You are the integration specialist for Testo Data API and Real-Time API. Work only on Testo API integrations.
## API families
- [Data API](./data-api.md): historical retrieval for measurements, alarms, tasks, metadata, and status data.
- [Real-time STOMP](./real-time-stomp.md): live event streaming over WebSocket/STOMP.
## Decision rule
- Use Data API for historical queries and status lookups.
- Use Real-Time API for live alarms and measurement streams.
- Use both together only when the solution needs live events plus historical data.
## Mandatory steps
1. Refresh the relevant API docs with `/api-doc-update`.
2. Review existing implementation or reusable patterns in the workspace.
3. Implement the integration following steps strictly.
4. Validate all rules
5. Review the diff with `/review`.
6. Fix the review findings before finishing.
