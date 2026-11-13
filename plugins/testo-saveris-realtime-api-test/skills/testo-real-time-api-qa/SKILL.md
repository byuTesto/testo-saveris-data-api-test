---
name: testo-real-time-api-qa
description: Provide answers related to Testo Real-Time API integration and usage. Use when users ask questions like 'How to onboard a new site to real time API', 'Invalid to subscribe a queue/topic', 'What does a physical value mean' or similar topics. Also use when triggered via /testo-real-time-api-qa with questions directly.
user-invocable: true
---

Provide answers to frequently asked questions regarding Testo Real-Time API integration and usage based on user context and input. If no input is provided, ask the user for more details about their issue or question.

**Important**: When answering questions, also refer to the API documentation. Use `/testo-real-time-api-doc` to fetch the latest. If no concrete answer available from documentation and below sections, inform the user accordingly and suggest contacting Testo support for further assistance. Do not provide speculative answers.

## Common Q&A guidelines
1. Credentials & region
  - Only supported credential type is Cognito `username/password`
  - Bearer token obtained from Cognito login must be included in the `Authorization` header for all STOMP and REST API requests.
  - The credential together with the token is region-specific and must be used with the corresponding region's base URL.
  - Credential is created by Testo with an API `username` bound with an email address; After creation an email with login information is sent to the account email.
  - Temporary password during registration expires after 5 days; contact Testo support if it expires.
  - When using AWS SDK, the Cognito client ID is region-specific and must match the region of the credential being used; Contact Testo support for Cognito client ID if necessary.

2. Tenant binding & site data
  - To fetch site data, the site/tenant should be bound to the user from Testo side, check with Testo support if necessary.
  - Response data should be identified based on `tenant_uuid` instead of location identifier or others.

3. Queue & permissions
  - Permissions are on queue level
    - Invalid subscription errors often occur due to missing permissions or incorrect queue/topic names.
    - Contact Testo support for assistance with granting queue permissions.
  - When a new version of queue is released, migration is essential since old one will become unsupported or deprecated very soon.

4. Data expiration & connectivity
  - Data in the real-time API may have a limited retention period.
  - Expired data will no longer be available through the API.
  - Poor connectivity from client side may result in missing real-time data before it expires.
  - There are two types of rate limits, listed below. The other connection errors, like timeout, broker unavailability and so on, should be handled properly by retries.
    - rate-limit-exceeded: wait for 10 minutes for next connection trial.
    - max-connections-reached: maximum 4 parallel connections.
  - If data gaps occur, they can be filled with historical data from Data API.

5. Detailed data issue - check with Testo support
  - Inconsistent or unexpected/null values for certain fields.
  - Data partially missing.

6. Concepts
  - Physical properties - refer below [Physical properties](#physical-properties) section or latest page at `https://developers.testo.dev/saveris-logger-api/general/physical-properties/` for more details.
  - Timestamp in data with `_local` suffix indicates the local time of the measurement, otherwise it represents the UTC time.

## Physical properties
Every measured quantity exposed by our APIs — in equipment metadata, device channels, alarms, and measurement messages — is described by three fields, always used together:
- `physical_value` — the pure physical property being measured, as you'd find it described in a science textbook (e.g. Temperature, Humidity).
- `physical_extension`/`physical_value_extension` — describes what is measured more precisely, if the sensor hardware can determine it. When the hardware has no further detail about what it's measuring (e.g. a general-purpose temperature sensor that doesn't know whether it's in air, water, or a product), the extension is Unknown.
- `physical_unit` — the unit the value is expressed in (e.g. °C, %rF).
Across current endpoints and message types, each physical_value/physical_extension pair has a single, consistent meaning, so no per-property special-casing is needed. Legacy endpoints use some different combinations — see the note below.

|physical_value|physical_extension|physical_unit|What it measures|
|-|-|-|-|
|Temperature|Unknown|°C or °F|General-purpose temperature.|
|Temperature|Product Temperature|°C or °F|Temperature measured in or on a product (e.g. food), rather than the surrounding air.|
|Temperature|Dew Point|°C or °F|The temperature at which moisture in the air starts to condense.|
|Humidity|Unknown|%rF|Relative humidity — how much moisture the air holds as a percentage of what it can hold at that temperature.|
|Density|Absolute Humidity|g/m³|Absolute humidity — the actual mass of water vapor per cubic meter of air, independent of temperature.|
|Unknown|Door Contact|number|Whether a monitored door or lid is open or closed.|
|Irradiance|Unknown|mW/m²|The intensity of radiant energy, such as sunlight, hitting a surface.|
|Flue gas values|CO2 carbon dioxide|ppm|Carbon dioxide (CO2) concentration in flue gas, in parts per million.|
|Pressure|Absolute Pressure|hPa|Absolute air or gas pressure, not adjusted for altitude or a reference value.|
|Illuminance|Unknown|lx|The intensity of light as perceived by the human eye.|
|Illuminance sum|Unknown|Lxh|Total light exposure accumulated over a period of time.|

## Scope
Answer questions related to Testo Real-Time API integration only. Do not provide answers for unrelated APIs. Always refer to the official API documentation and provided sections & pages for accurate information.