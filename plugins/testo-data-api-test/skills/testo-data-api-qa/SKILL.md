---
name: testo-data-api-qa
description: Provide answers related to Testo Data API integration and usage. Use when users ask questions related to non-technical aspects like 'How to onboard a new site to API account', 'Timeout using sync API', 'What does a physical value mean' or similar topics. Also use when triggered via /testo-data-api-qa with questions directly.
user-invocable: true
---

Provide answers to frequently asked questions regarding Testo Data API integration and usage based on user context and input. If no input is provided, ask the user for more details about their issue or question.

**Important**: When answering questions, also refer to the API documentation. Use `/testo-data-api-doc` to fetch the latest. If no concrete answer available from documentation and below sections, inform the user accordingly and suggest contacting Testo support for further assistance. Do not provide speculative answers.

## Common Q&A guidelines
1. Credentials & region
  - Only supported credential type is `username/password` and bearer token for Data API; API-key type is not supported
    - Credential for Data API is from AWS Cognito instead of the Auth0 one for website UI.
    - Wrong username/password results in a 400 Bad Request response for token request.
    - Missing/wrong auth token or using wrong auth method like API-key results in a 401 Unauthorized response.
    - Expired auth token results in a 403 Forbidden response.
  - Credential is created by Testo with an API `username` bound with an email address; After creation an email with login information is sent to the account email.
    - Temporary password during registration expires after 5 days; contact Testo support if it expires.
  - The credential is region-specific and must be used with the corresponding region's base URL.
    - Resulting in a 400 Bad Request response if the region does not match the credential for token request.
    - 401 Unauthorized response if a valid token is used with a mismatched region for subsequent API requests.

2. Tenant binding & site data
  - To fetch site data, the site/tenant should be bound to the user from Testo side, check with Testo support if necessary.
    - Wrong or missing binding results in a success response with an HTTP 200 status and an empty data set for corresponding tenant.
  - Response data should be identified based on `tenant_uuid` instead of location identifier or others.

3. Endpoints & versioning
  - Timeout or too large request payloads are known issues with sync endpoints.
    - Timeout may result in a 504 Gateway Timeout.
    - Too large request payloads result in a 413 Payload Too Large response.
  - Sync endpoints are deprecated and will be removed in future versions of the API; migrate to use corresponding non-deprecated async endpoints instead.
    - Using a non-existing endpoint results in a 403 Forbidden response.
  - Always check the endpoint documentation for the latest updates and deprecation notices; new version is always recommended to use.

4. Detailed data issue - check with Testo support
  - Inconsistent or unexpected/null values for certain fields.
  - Data partially missing for a specific time period only.
  - Unexpected data mapping/structure like tenant hierarchy mismatches.

5. Concepts
  - Physical properties - refer below [Physical properties](#physical-properties) section or latest page at `https://developers.testo.dev/saveris-logger-api/general/physical-properties/` for more details.
  - Timestamp in data with `_local` suffix indicates the local time of the measurement, otherwise it represents the UTC time.

## Physical properties
Every measured quantity exposed by our APIs — in equipment metadata, device channels, alarms, and measurement messages — is described by three fields, always used together:
- `physical_value` — the pure physical property being measured, as you'd find it described in a science textbook (e.g. Temperature, Humidity).
- `physical_extension` — describes what is measured more precisely, if the sensor hardware can determine it. When the hardware has no further detail about what it's measuring (e.g. a general-purpose temperature sensor that doesn't know whether it's in air, water, or a product), the extension is Unknown.
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
Answer questions related to Testo Data API integration only. Do not provide answers for unrelated APIs. Always refer to the official API documentation and provided sections & pages for accurate information.