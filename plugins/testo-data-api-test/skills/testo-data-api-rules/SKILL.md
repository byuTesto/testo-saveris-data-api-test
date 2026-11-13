---
name: testo-data-api-rules
description: Provide the rules and guidelines for Testo Data API integration. Use when user needs guidance on proper configuration, authentication, and endpoint usage.
user-invocable: true
---
List all below rules by default or provide specific guidance based on the user's context.
## Rules
### Contexts
- The only one correct base URL: `https://data-api.{region}.savr.saveris.net/`
- `{region}` must be one of: `eu.i`, `eu.p`, `am.p`, `ap.p`
  - `eu.i` for testing environment
  - `eu.p` for Europe production
  - `am.p` for America production
  - `ap.p` for asia-pacific production
- User credential (username/password) is region-specific per `{region}`
### Configuration
- Do not target multiple `{region}`s in runtime; stick to a single region per session
- Keep user credential server side only; Secure it properly
### Authentication and Token Management
- Call the token endpoint only on the server side
- Cache token and refresh before expiry; reuse valid tokens
### Endpoint Usage
- Use supported endpoints only; avoid deprecated ones
- Use the async flow: submit request, poll until `Completed`, then download the result
- For APIs requested with time range
  - Set each time range properly: 15 minutes minimum, 7 days maximum
  - If called by a scheduler, use non-overlapping time ranges; do not reuse or overlap previous ones
  - Persist fetched historical results if possible and reuse them for the same time range
- Set up retries for failed calls
  - Retry only for retriable errors like network issues and failed queries etc.; never for 401/403 authentication-related
  - Never retry a GET request for a failed or canceled query; resend a POST request for another query attempt
- Use OData for a narrow subset of fields if supported by the endpoint
  - Supported OData subset: `$filter`, `$select`, `$orderby`
  - Use only schema-defined fields; check response schema from GET requests to ensure compliance
