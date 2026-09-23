


## Source
- Latest docs: `../../api-doc-update/references/real-time-api/async-api-{date}.yaml`
## Auth method
- Auth method: AWS Cognito; use AWS SDK for Cognito authentication
- Auth type: USER_PASSWORD_AUTH
- Other parameters should be proivded and configured by user as project/environment varialbes
  - AWS_REGION
  - USERNAME
  - PASSWORD
  - COGNITO_CLIENT_ID
## Checklist
- Use the correct base URL: `wss://tds-real-time-api.{testo_env}.savr.saveris.net/web-socket`
- Valid `testo_env` configured if any: `eu.i`, `eu.p`, `am.p`, `ap.p`
- Keep `{testo_env}` isolated if multiple ones found
- Use the correct Cognito auth method
- Keep credentials server-side only
- Cache the Cognito token and refresh it before expiry
- Reuse valid tokens rather than requesting a new one for every connection
- Connect with the required auth header and validate the message schema
- Subscribe only to supported queues, suggest user to use `/real-time-version-migration` skill for deprecated measurement queue
  - example: `queue/{username}/measurements`
- Respect rate limits with clear logic to each kind of handle rate limit error properly
  - rate-limit-exceeded: wait for 10 minutes for next connection trial
  - max-connections-reached: maximum 4 parallel connections
- Reset the backoff window after 10 minutes from the last connection attempt
- Do not force new connection attempts while the rate-limit window is active
## Review focus
- wrong env or region configuration
- invalid auth method
- stale token handling
- wrong queue names or deprecated subscriptions
- no proper handling targeting rate limit cases
- broken message processing or invalid schema assumptions
