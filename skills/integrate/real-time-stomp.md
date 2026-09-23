# Real-Time STOMP
Use this for live alarm and measurement streaming.

## Source and setup
- Primary reference: `../audit/references/real-time-stomp.md`
- WebSocket URL: `wss://tds-real-time-api.{testo_env}.savr.saveris.net/web-socket`
- Make `{testo_env}`configurable
- Keep credentials server-side only.
- Cache the Cognito token and refresh before expiry.
- Stop and ask the user before making risky or breaking changes.
## Steps
1. Before the first integration of this API, pause and ask user to confirm: "Please confirm that you have permission to use Testo Saveris Push API".
2. Get a Cognito token.
3. Connect to the STOMP WebSocket endpoint.
4. Send the Cognito token in the `Authorization` header on CONNECT.
5. Subscribe to the correct queue; for measurement queue, provide a API guide for user to fetch version setting information, then pause and ask user to conform the activated version.
   - Version settings API: `../api-doc-update/references/real-time-api/openapi.yaml`
   - Show the API steps to fetch version settings and pause for the JSON response.
6. Handle reconnects and buffered messages normally.
7. Process and persist incoming data when required.
## Rules
- Use the correct env-specific Cognito `ClientId` and region.
- Reuse valid tokens instead of requesting a new one for every connection.
- Subscribe only to supported queues, suggest user to use `/real-time-version-migration` if legacy queue is used
- Respect rate limits with clear logic to each kind of handle rate limit error properly.
- Reset the backoff window after 10 minutes from the last connection attempt.
- Do not force any new connections while the rate-limit window is active.

## Troubleshooting
1. Check host and endpoint version.
2. Check Cognito auth and token validity.
3. Check CONNECT and subscription state.
4. Check the queue name, payload schema, and permission state.
5. Check reconnect and buffer behavior.
6. Check for deprecated queues or unsupported subscription targets.

Stop after the above checks fail to explain the behavior.
