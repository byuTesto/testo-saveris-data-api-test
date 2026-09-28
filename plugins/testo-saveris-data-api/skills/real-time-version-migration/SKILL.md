---
description: Guide user to migrate to new version queue for real-time STOMP.
user-invocable: true
---
Help and guide user to migrate to new version measurement queue for real-time STOMP.

## Workflow
1. Refresh the relevant API docs with `/api-doc-update`.
2. Check to know where is it now for "Guided steps"
3. Start or continue with the steps
## Guided steps
1. Check whether version 2 measurement queue logic already exists.
   - If not, ask: "Do you want to implement the version 2 measurement queue now?"
   - Stop if the answer is no.
2. Implement a parallel version 2 path using the version 2 schema, without changing the legacy implementation.
3. Ask: "Have you already scheduled the version switch via API?"
   - If no, give the user the scheduling steps, stop, and ask them to resume after scheduling.
   - If yes, continue.
4. Show the API steps to fetch version settings and pause for the JSON response.
5. Evaluate the switch state from the returned version settings:
   - If the switch has not started yet, do not act on the live queue; remind the user to validate after `activeFrom`.
   - If the switch is in the 4-hour transition window, instruct the user to validate that both legacy and version 2 queues are receiving expected messages.
   - If the transition window has already passed, continue to Step 7 for cleanup.
6. If the switch is before activation or still inside the transition window, provide cancelation guidance using the correct API parameter for the current state.
7. After the transition window has passed, review legacy queue code paths and ask: "Should the legacy queue code be removed?"
   - Do not remove it if the answer is no.
## API docs
- Version settings API: `../api-doc-update/references/real-time-api/openapi.yaml`
- Real-Time STOMP: `../api-doc-update/references/real-time-api/async-api.yaml`
## Scop
Real-time measurement queue related code and logic only. 
