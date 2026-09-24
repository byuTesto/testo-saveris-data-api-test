
## Source
- Latest docs: `../../api-doc-update/references/data-api/data-api-docs-{date}.json`
## Checklist
- Use the only one correct base URL: `https://data-api.{testo_env}.savr.saveris.net/`
- Valid `{testo_env}` configured if any: `eu.i`, `eu.p`, `am.p`, `ap.p`
- Keep `{testo_env}` isolated if multiple ones found
- Keep credentials server-side only
- Call the token endpoint only on the server side
- Cache tokens and refresh before expiry; reuse valid tokens
- Use supported endpoints only; avoid deprecated ones
- Use the async historical flow: submit request, poll until `Completed`, then download the result
- Keep each time window valid: 5 minutes minimum, 7 days maximum
- If the API is called by scheduler automatically, use non-overlapping incremental time ranges; do not reuse or overlap previous ranges
- Retry failed calls only when the failure is not authentication-related
  - resend the POST request when retrying
  - never retry a failed GET request for the same query
- Persist fetched historical results and reuse them for the same range
  - group by resource UUID, tenant, and time range as needed
- Validate OData support on each endpoint
  - supported subset: `$filter`, `$select`, `$orderby`
  - use only schema-defined fields

## Review focus
- invalid/deprecated endpoints
- duplicate or overlapping historical requests
- incorrect token caching or refresh logic
- missing retries for non-auth failures
- bad persistence and range reuse
