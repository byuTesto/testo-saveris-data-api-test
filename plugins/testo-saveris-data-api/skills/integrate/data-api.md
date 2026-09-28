# Data API
Use this for historical retrieval only.

## Source and rules
- Primary reference: `../audit/references/data-api.md`
- Only valid base URL: `https://data-api.{testo_env}.savr.saveris.net/`
-  Make `{testo_env}`configurable
- Keep credentials server-side only.
- Use the token endpoint only on the server.
- Reuse a valid token; refresh before expiry.
- Re-query only when needed; do not duplicate historical fetches.
- Use supported endpoints only; avoid deprecated ones.
- Stop and ask the user before making risky or breaking changes.
## Steps
1. Before the first integration of this API, pause and ask user to confirm: "Please confirm that you have permission to use Testo Saveris Data API".
2. Get a token with `POST /v1/token`.
3. Send the bearer token in the `Authorization` header.
4. Submit the historical request with the async pattern.
   - POST request like `POST /v3/alarms`, capture `request_uuid`.
   - Poll `GET /v3/alarms/{request_uuid}` until status is `Completed`.
   - Download the result from the returned pre-signed URL.
## Query rules
- Window must be 5 minutes to 7 days.
- Use non-overlapping incremental ranges.
- Re-query only for missing, incomplete, or refreshed ranges.
- Retry failed calls only when the failure is not authentication-related.
  - Resend the POST request when retrying.
  - Do not retry a failed GET request for the same query.
- Do not repeat the same historical query unless re-query conditions apply.
## OData
- Only use supported operators: `$filter`, `$select`, `$orderby`.
- Validate field names against the schema or response model.
- Prefer OData only when a narrow subset of fields is needed.
## Troubleshooting
1. Check host and endpoint version.
2. Check auth token validity.
3. Verify async status and polling loop.
4. Check time range, payload shape, and sampling cadence.
5. Check for duplicate historical queries and cached results.
6. Check OData field names and supported operators.
7. Check the result URL for historical downloads.

Stop only after the above checks fail to explain the behavior.
