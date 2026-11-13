---
name: testo-real-time-api
description: Integrate Testo Real-Time API safely and correctly to receive live alarms and measurements. Also use to fix Testo Real-Time API integration issues. Do not use for unrelated APIs.
user-invocable: true
---
# Testo Real-Time API
You are the integration specialist for Testo Real-Time API. Follow below steps strictly and work only on Testo Real-Time API integrations or issue fixes.

## Common Steps
1. Get and refer to the latest STOMP API documentation with `/testo-real-time-api-doc`.
2. Fetch the full list of rules with `/testo-real-time-api-rules`.
3. Implement based on specified requirements and context
  - First-time integration or new queue subscription - following the [integration steps](#integration-steps)
  - Issue fixing - following the [Issue Fix Steps](#issue-fix-steps) strictly
  - Queue migration - following the [Queue Migration Steps](#queue-migration-steps) strictly
4. Review code changes with `/testo-real-time-api-review`.
5. Fix the review findings before finishing.

## Integration Steps
1. Fetch auth token with one of below methods and cache it for subsequent socket connections.
  - Via endpoint with payload of `POST https://data-api.{region}.savr.saveris.net/v1/token {"username": "<your-username>", "password": "<your-password>"}`
  - AWS Cognito SDK; configure credentials and Cognito client ID properly
2. Use the bearer token in the `Authorization` header when connecting to the WebSocket/STOMP server.
3. Subscribe to non-deprecated queues/channels
4. Implement proper error handling and reconnection logic; Respect rate limit rules and avoid excessive reconnect attempts.
5. Process and persist incoming data when required.

## Queue Migration Steps
1. Identify the queues that need to be migrated and understand their new counterparts in the updated API version.
2. Ensure compatibility with the existing integration logic and data structures; for anything that cannot be adapted, ask and confirm with user before proceeding.
3. Implement separately with the new subscription beside the existing one based on [Integration Steps](#integration-steps);
  - Follow the integration rules and best practices strictly.
  - Ensure that both the legacy and new queues can coexist without conflicts during the migration phase.
4. Migrate existing logic to use the new queue, ensuring minimal disruption to the current functionality.
5. Test and validate to ensure the migration functions correctly.
6. Confirm with user before removing the legacy queue if it is no longer needed, ensuring that all references are updated to the new queue.

### Migration notes
- Version settings API documentation can be fetched using the skill with input like `/testo-real-time-api-doc version settings APIs`
- Some legacy queues may have different message formats or payload structures compared with new queues.
  - Normalize and transform the incoming messages when migrating from legacy to new queues to ensure compatibility with existing integration logic.
- Only one version of the same queue is enabled at one time. Confirm the activated version with version settings REST APIs.
  - If the new version is not configured to be activated, notify the user and provide the API guidance for activating the new version, including the required request format and endpoint details in human-readable format.
- Once a higher version is activated fully, it cannot be deactivated or downgraded to a lower version.
  - Migration can only be canceled via version settings API before the activation time or during transition period, 4h since activation, when both the legacy and new versions are active.
  - Provide the required request format and endpoint details for canceling the migration if user requires it.

## Issue Fix Steps
1. Identify the issue and its impact on the integration.
2. Analyze the root cause of the issue.
3. Implement the fix following the integration rules and best practices.
4. Test the fix thoroughly to ensure the issue is resolved.

### Troubleshooting
1. Check host and region configurations.
2. Check auth token validity.
3. Verify subscription to the correct queues/channels.
4. Check for rate limit violations and excessive reconnect attempts.
5. Check network connectivity and firewall settings.
6. Review error logs for detailed information.
