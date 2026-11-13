---
name: testo-real-time-api-rules
description: Provide the rules and guidelines for Testo Real-Time API integration. Use when user needs guidance on proper configuration, authentication, and endpoint usage.
user-invocable: true
---
List all below rules by default or provide specific guidance based on the user's context.
## Rules
### Contexts
- The only one correct socket base URL: `wss://tds-real-time-api.{region}.savr.saveris.net/web-socket`
- Available REST token endpoint: `https://data-api.{region}.savr.saveris.net/v1/token`
- `{region}` must be one of: `eu.i`, `eu.p`, `am.p`, `ap.p`
  - `eu.i` for testing environment with AWS_REGION of `eu-central-1`
  - `eu.p` for Europe production with AWS_REGION of `eu-central-1`
  - `am.p` for America production with AWS_REGION of `us-west-2`
  - `ap.p` for asia-pacific production with AWS_REGION of `ap-southeast-1`
- User credential (username/password) is region-specific per `{region}` and AWS region when using SDK
### Configuration
- Do not target multiple `{region}`s in runtime; stick to a single region per session
- Keep user credential server side only; Secure it properly
### Authentication and Token Management
- Fetch the token and keep credentials on server side only using one of below methods:
  - AWS Cognito authentication SDK (recommended)
  - Calling the token endpoint
- Cache token and refresh before expiry; reuse valid tokens
### Socket Connection
- Avoid subscribing to deprecated queues; use the new versions
- Respect rate limits and handle each kind of error properly
  - rate-limit-exceeded: wait for 10 minutes for next connection trial
  - max-connections-reached: maximum 4 parallel connections
- Do not force new connection attempts while the rate-limit window is active
