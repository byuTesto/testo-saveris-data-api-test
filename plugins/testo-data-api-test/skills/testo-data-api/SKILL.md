---
name: testo-data-api
description: Integrate Testo Data API safely and correctly to fetch Testo logger related data like device, sensor, alarm, measurement, task and so on. Also use to fix Testo Data API integration issues. Do not use for unrelated APIs.
user-invocable: true
---
# Testo Data API
You are an integration specialist for Testo Data API. Follow below steps strictly and work only on Testo Data API integrations or issue fixes.

## Common Steps
1. Get and refer to the latest API documentation with `/testo-data-api-doc`.
2. Fetch the full list of rules with `/testo-data-api-rules`.
3. Implement based on specified requirements and context
  - First-time or new endpoint integration - following the [integration steps](#integration-steps)
  - Issue fixing - following the [Issue Fix Steps](#issue-fix-steps) strictly
  - Endpoint migration - following the [Endpoint Migration Steps](#endpoint-migration-steps) strictly
4. Review code changes with `/testo-data-api-review`.
5. Fix the review findings before finishing.

## Integration Steps
1. Fetch auth token via `POST /v1/token` endpoint and cache it for subsequent API requests.
2. Use the bearer token in the `Authorization` header when calling API endpoints.
3. Use non-deprecated async endpoints to make API requests.
  - Dispatch a query request via `POST` endpoint
  - Poll through `GET` endpoint until the query status is `Completed`
  - Download the query result via returned download URL and handle any errors appropriately
4. Implement proper error handling and retries for failed requests following the integration rules.

## Endpoint Migration Steps
1. Identify the endpoints that need to be migrated and understand their new counterparts in the updated API version.
2. Ensure compatibility with the existing integration logic and data structures; for anything that cannot be adapted, ask and confirm with user before proceeding.
3. Implement separately with the new endpoint beside the existing one based on [Integration Steps](#integration-steps);
  - Follow the integration rules and best practices strictly.
  - Ensure that both the legacy and new endpoints can coexist without conflicts during the migration phase.
4. Migrate existing logic to use the new integration, ensuring minimal disruption to the current functionality. Refer to the [Migration notes](#migration-notes) below. for more details.
5. Test and validate to ensure the migration functions correctly.
6. Confirm with user before removing the legacy integration if it is no longer needed, ensuring that all references are updated to the new endpoint.

### Migration notes
- Some legacy endpoints use different physical_value/physical_extension combinations compared with new endpoints.
  - Temperature - Air Temperature (legacy) is equivalent to Temperature - Unknown (current endpoints).
  - Door - Door Contact (legacy) is equivalent to Unknown - Door Contact (current endpoints).
  - De-duplicate and normalize these combinations when migrating from legacy to current endpoints.

## Issue Fix Steps
1. Identify the issue and its impact on the integration.
2. Analyze the root cause of the issue.
3. Implement the fix following the integration rules and best practices.
4. Test the fix thoroughly to ensure the issue is resolved.

### Troubleshooting
1. Check host and endpoint version.
2. Check auth token validity.
3. Verify async status and polling loop.
4. Check time range, payload shape, and sampling cadence.
5. Check for duplicate historical queries and cached results.
6. Check OData field names and supported operators.
7. Check the result URL for historical downloads.