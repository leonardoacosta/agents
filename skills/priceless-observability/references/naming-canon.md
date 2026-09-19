# Priceless observability naming canon

Status: draft canon, created from observed fleet usage on 2026-08-08.
Scope: Priceless fleet projects using shared Grafana/Loki/Tempo/OpenReplay infrastructure.

## Why this exists

Cross-project observability only works when the same concept has the same name in every surface. Grafana labels, OpenReplay events, OTel resources, Vercel drains, and app log events should line up so an operator can move from a browser session to a Loki query to a Tempo trace without translating ad hoc names.

## Observed evidence

Live Grafana/Loki label probes on 2026-08-08 showed:

- `project` includes `civalent`, `otaku-odyssey`, `tribal-cities`.
- `job` includes `vercel-logs` and service jobs such as `oo-api`.
- `environment` includes `preview`, `production`.
- `service_name` includes service-style values such as `oo-api`.
- Loki datasource UID is `loki`.
- Working query path: `/api/datasources/proxy/uid/loki/loki/api/v1/query_range`.

Repository/spec examples showed:

- Civalent specs query `{job="vercel-logs", project="civalent"}`.
- Tribal Cities specs query `{project="tribal-cities"}`.
- Otaku Odyssey collector queries `{project="otaku-odyssey"}`.
- Next.js apps use `NEXT_PUBLIC_OPENREPLAY_PROJECT_KEY`.
- Expo uses `EXPO_PUBLIC_OPENREPLAY_PROJECT_KEY`.
- Existing event names mix canonical and legacy styles: `email.confirmation.sent`, `email.confirmation.provider_failed`, `auth.client.error`, `volunteer.swap.pending-approval`, plus drift such as `email.qr_mint_failed`, `commerce_writes_frozen_block`, `chat_opened`, and `socket:connected`.

## Canonical identifiers

### Project slug

Use the repository slug in kebab-case. This value is shared across Loki `project`, dashboards, runbooks, and cross-project docs.

Examples:

| Repo | Canonical project |
| --- | --- |
| `otaku-odyssey` | `otaku-odyssey` |
| `tribal-cities` | `tribal-cities` |
| `civalent` | `civalent` |
| `modern-visa` | `modern-visa` |
| `las-vegas` | `las-vegas` |
| `tavern-ledger` | `tavern-ledger` |

Do not use brand display names, package names, or short aliases as the `project` label.

### Short project code

Use short codes only where a compact service name is useful. Do not use short codes for the Loki `project` label.

| Project | Short code |
| --- | --- |
| `otaku-odyssey` | `oo` |
| `tribal-cities` | `tc` |
| `civalent` | `ct` |
| `modern-visa` | `mv` |
| `las-vegas` | `lv` |
| `tavern-ledger` | `tl` |

### Service names

Use `<short-project>-<component>` for OTel `service.name` and Loki `service_name` values.

Canonical components:

- `api`: server/API runtime, tRPC, route handlers, webhooks.
- `web`: browser/front-end runtime when represented as a service.
- `worker`: background jobs, queue workers, scheduled processors.
- `socket`: websocket/socket runtime.
- `e2e`: test runner or synthetic acceptance agent.

Examples:

- `oo-api`
- `tc-api`
- `ct-web`
- `tl-socket`

Avoid old ambiguous values such as `oo` as a service name. Keep them only in legacy queries while migrating.

### Environment

Use exactly one of:

- `development`
- `test`
- `preview`
- `production`

Do not introduce `dev`, `prod`, `staging`, `local`, or Vercel-specific aliases in telemetry labels unless bridging a vendor that cannot be configured otherwise. Normalize at the bridge when possible.

## Loki and Grafana conventions

### Required labels for Vercel logs

- `project`: repo slug, kebab-case.
- `job`: `vercel-logs` for Vercel drain logs.
- `environment`: `preview` or `production` where available.
- `service_name` or `service.name`: service identifier when available.

### Query shape

Prefer bounded, metadata-focused LogQL. Assert counts and labels, not raw log contents.

Good:

```logql
{job="vercel-logs", project="otaku-odyssey"} |~ "email.confirmation.(sent|order_missing|qr_mint_failed|provider_failed)"
```

Good for a project-wide smoke:

```logql
{project="civalent", job="vercel-logs"} |= "blob.upload.route"
```

Avoid:

- Unbounded queries.
- Queries that require printing raw log bodies into transcripts.
- Queries that contain token, email, session, or credential values.
- Project selectors using display names or short aliases.

### Grafana datasource proxy

Use the datasource UID form so URLs survive datasource ID changes:

```text
/api/datasources/proxy/uid/loki/loki/api/v1/query_range
/api/datasources/proxy/uid/tempo/api/traces/{traceId}
```

Avoid numeric datasource IDs such as `/proxy/1/...` for new code.

## Event naming

### New server and client events

Use dot-delimited names:

```text
<domain>.<entity?>.<action|outcome>
```

Rules:

- Lowercase only.
- Use dots for hierarchy.
- Use underscores inside one segment only when the business term is already an underscore-style outcome, e.g. `provider_failed`.
- Do not use colons for new events.
- Do not use bare snake_case for new events.
- Use past-tense outcomes for facts that happened: `sent`, `provider_failed`, `checkout_started` only if that is a captured action event.
- Use domain names that match code ownership: `auth`, `email`, `checkout`, `badge`, `volunteer`, `ticket`, `blob`, `payment`, `socket`.

Examples:

| Meaning | Canonical event |
| --- | --- |
| Confirmation email sent | `email.confirmation.sent` |
| Confirmation email provider failure | `email.confirmation.provider_failed` |
| Missing order for confirmation email | `email.confirmation.order_missing` |
| QR mint failed during confirmation | `email.confirmation.qr_mint_failed` |
| Client auth error | `auth.client.error` |
| Volunteer swap pending approval | `volunteer.swap.pending-approval` |
| Blob upload route warning | `blob.upload.route.warning` |
| Chat opened | `chat.opened` |
| Socket connected | `socket.connected` |

### Legacy names to bridge, not copy

These names exist and should be recognized in queries, but new events should not copy their style:

| Legacy/drift name | New-style equivalent |
| --- | --- |
| `email.qr_mint_failed` | `email.confirmation.qr_mint_failed` when scoped to confirmation flow |
| `commerce_writes_frozen_block` | `commerce.writes.frozen_block` or more specific route event |
| `chat_opened` | `chat.opened` |
| `booking_started` | `booking.started` |
| `booking_completed` | `booking.completed` |
| `socket:connected` | `socket.connected` |
| `socket:event:{name}` | `socket.event.<name>` |

Do not rename emitted production events casually. First add queries/dashboards that include both old and new names, then switch emission, then remove bridge queries after the retention window and dependent dashboards are updated.

## OpenReplay conventions

Research source URLs checked on 2026-08-08:

- `https://docs.openreplay.com/en/product-analytics/`
- `https://docs.openreplay.com/en/product-analytics/custom-events/`
- `https://docs.openreplay.com/en/product-analytics/dashboards/`
- `https://docs.openreplay.com/en/product-analytics/monitors/`
- `https://docs.openreplay.com/en/product-analytics/web-analytics/`

### Product Analytics model

OpenReplay Product Analytics is dashboard/card-oriented. Dashboards can combine three categories:

- **Product analytics:** Trends, Funnels, Journeys, Heatmaps, and custom-event-driven product behavior.
- **Monitors:** technical health cards for JavaScript errors, top network requests, 4xx/5xx requests, and slow network requests.
- **Web Analytics:** traffic and usage cards such as top pages, browsers, referrers, and related web metrics.

Implication for Priceless projects: do not invent separate project names per dashboard. One OpenReplay project should map to the same repo slug used by Grafana/Loki. Dashboard names describe the lens, not the project identity.

Canonical dashboard names:

| Dashboard | Purpose |
| --- | --- |
| `Product Analytics` | user behavior, custom events, funnels, trends, journeys |
| `Monitors` | JS errors, 4xx/5xx, slow requests, top network requests |
| `Web Analytics` | top pages, browser/referrer/traffic patterns |

For project-specific variants, prefix with the project slug: `otaku-odyssey / Monitors`, `civalent / Web Analytics`.

### Implementation policy

Use three policy levels:

- **Enforce:** required for production/preview observability correctness. Add tests, config checks, or CI gates when feasible.
- **Encourage:** preferred for product insight, but do not block delivery unless the feature explicitly depends on it.
- **Defer:** useful later, but not part of the current change unless the work is already touching that surface.

| OpenReplay area | When to implement | Where to implement | How to implement | Policy |
| --- | --- | --- | --- | --- |
| Base OpenReplay provider | Every browser app that ships user-facing flows | App root/provider layer, e.g. `OpenReplayProvider`; typed env schema | Initialize only when project key is present. No-op when absent. Use canonical project key and ingest env names. | **Enforce** for apps that have OpenReplay enabled; provider must not crash when env is absent |
| Product Analytics dashboard | When a product flow has conversion or behavior questions, e.g. checkout, onboarding, booking, application flows | OpenReplay dashboard named `Product Analytics` or `<project> / Product Analytics`; event emitters near the user action boundary | Add `tracker.event(...)` functional events for durable product milestones. Use dot-delimited names shared with server events. Add funnels/trends from those events. | **Encourage** by default; **enforce** for revenue, auth, checkout, onboarding, and safety-critical flows |
| Functional custom events | When a user action or business outcome must be searchable/filterable in OpenReplay | Client instrumentation wrapper, never scattered raw SDK calls if the project has a wrapper | Call `tracker.event(name, payload)` after tracker start. Keep payload non-recursive, low-cardinality, and free of secrets/PII. | **Enforce** for named acceptance-critical funnel steps; otherwise **encourage** |
| Technical custom events | When client errors, failed network-dependent actions, downstream failures, or degraded UX need replay correlation | Error boundary, mutation error handlers, auth/payment/upload/client API wrappers | Call `tracker.issue(name, payload)` for technical events. Pair with existing logger/Grafana event where possible. | **Enforce** for unhandled client errors and critical failed mutations; **encourage** for recoverable UI issues |
| Monitors dashboard | When the app has OpenReplay enabled and receives real preview/production traffic | OpenReplay dashboard named `Monitors` or `<project> / Monitors` | Add cards for JS Errors, Top Network Requests, Sessions with 4xx/5xx Requests, and Slow Network Requests. Use this as the technical-health lens, not as product funnel tracking. | **Enforce** for production apps with OpenReplay; **encourage** for preview-only or low-traffic apps |
| Web Analytics dashboard | When product, marketing, or ops needs high-level usage and traffic shape | OpenReplay dashboard named `Web Analytics` or `<project> / Web Analytics` | Add cards for Top Pages, browsers, referrers, and traffic patterns. Use existing URL/page metadata rather than custom events unless a route needs business naming. | **Encourage** by default; **enforce** only for marketing/landing-page or growth work |
| Replay fidelity and styling | When enabling OpenReplay, when sessions replay as raw HTML/no CSS, or when visual evidence will be used for QA/incidents | Tracker constructor, asset/CDN/CSP configuration, preview/prod deploy checklist | Use the reliability baseline below. Prefer `inlineCss: 3` when asset reachability cannot be proven. Use backend asset caching only after CSS/fonts/icons are reachable from OpenReplay and CDN/bot protection allows the fetch. | **Enforce** before relying on replay screenshots for production support; **encourage** for preview-only validation |
| Cross-tool correlation | When an event also appears in Grafana/Loki/OTel or is used during incident response | Event naming canon, logger helpers, OpenReplay wrapper, dashboard queries | Use the same event name across OpenReplay and structured logs. If legacy names exist, bridge old and new names in dashboards until retention expires. | **Enforce** for incident/debug workflows |

### Enforcement ladder

1. **Naming-only lint/unit check:** enforce env key names, provider no-op behavior, and event-name grammar in code.
2. **Runtime smoke:** verify OpenReplay provider starts when the project key exists and remains transparent when absent.
3. **Dashboard checklist:** manual or scripted setup confirms required Product Analytics, Monitors, and Web Analytics dashboards/cards exist.
4. **Acceptance evidence:** for critical flows, exercise the flow and confirm the OpenReplay event or monitor card can find the session.

Do not enforce dashboard existence in ordinary unit tests unless the project has an API/export path for dashboard metadata. Prefer a documented operations checklist over brittle browser automation of the OpenReplay UI.

### Reliable replay styling and asset capture

Firecrawl research sources used for this section:

- `https://docs.openreplay.com/en/troubleshooting/session-recordings/`
- `https://docs.openreplay.com/en/sdk/constructor/#stylesheets`
- `https://forum.openreplay.com/t/styles-are-missing-which-causes-a-messy-session-replay/69`
- `https://forum.openreplay.com/t/styles-are-messed-up/469`
- `https://github.com/openreplay/openreplay/issues/541`

OpenReplay replays are reliable only when the tracker can capture enough style data for replay. The official docs say OpenReplay needs access to CSS, fonts, and icons so the backend can copy/cache them, and that `inlineCss: 3` records stylesheets as replay messages instead of relying on backend caching. That makes `inlineCss: 3` the safest baseline when a Priceless app uses protected previews, private domains, auth-gated pages, or CDN rules that may block backend asset fetches.

#### Reliability baseline for Priceless apps

Use this baseline before trusting replay screenshots for QA, support, or incident evidence:

1. **HTTPS and CSP:** run OpenReplay only on HTTPS pages and include the required OpenReplay CSP. If the tracker never starts, fix HTTPS/CSP before debugging CSS.
2. **Single tracker instance:** start the tracker once. Duplicate snippet + npm initialization can prevent or corrupt recordings.
3. **Style capture default:** set `inlineCss: 3` whenever assets are private, preview-protected, behind auth, behind bot-sensitive CDN rules, generated by the app build, or repeatedly missing in replay.
4. **CSS-in-JS fallback:** when Emotion/MUI or similar CSS-in-JS styles are missing even with stylesheet capture, enable the SDK `css` options, especially `scanInMemoryCSS`, with bounded `checkCssInterval` and `checkLimit` values.
5. **Backend cache path:** use default backend caching only when CSS/fonts/icons are public and you have verified the OpenReplay backend or documented OpenReplay cloud source IPs are allowed through CDN/bot protection.
6. **`resourceBaseHref` path:** use `resourceBaseHref` only when the app deliberately mirrors CSS/fonts/icons to a stable public asset origin. Do not point it at localhost, private previews, expiring signed URLs, or auth-gated Vercel URLs.
7. **Replay-fidelity smoke:** after deploy, record one short session and inspect the replay iframe Network panel. CSS, fonts, and icons should load without 4xx/5xx, CSP, CORS, or bot-block responses.
8. **Evidence rule:** if the replay is unstyled, report a replay-fidelity failure and validate UI appearance with a real browser or Playwright screenshot before making visual QA claims.

Common causes:

| Symptom | Likely cause | Check | Fix |
| --- | --- | --- | --- |
| Replay shows raw HTML/default browser styles | CSS files are private, protected by preview auth, or not publicly reachable from OpenReplay | Open the replay iframe's Network panel and filter CSS/font/icon requests | Prefer `inlineCss: 3` in the tracker constructor for private/protected assets |
| Works for users but replay misses styles | CDN or bot protection, commonly Cloudflare, blocks OpenReplay backend asset fetches | Check CSS/font/icon responses and CDN firewall/bot logs | Whitelist the OpenReplay backend/source IPs for asset fetches, or use `inlineCss: 3` |
| Localhost replay has no styles | OpenReplay cannot fetch assets from the developer machine | Confirm the recording was made on localhost | Use `inlineCss: 3` for local/private testing, or test from an HTTPS preview URL with reachable assets |
| Same-origin iframe styles are missing | Frame CSS links are relative or nested frames cannot resolve assets | Inspect `<link rel="stylesheet">` URLs inside the replay iframe | Use absolute stylesheet URLs in frames or configure `resourceBaseHref` |
| Self-hosted replay has intermittent missing bits | Asset cache or beacon-size/backend ingestion limits | Inspect replay iframe network/console, then self-hosted `assets` service logs | Fix asset service/cache errors; if payloads are truncated, raise the documented beacon/body-size limits |

Minimal tracker shape:

```ts
const tracker = new OpenReplay({
  projectKey: env.NEXT_PUBLIC_OPENREPLAY_PROJECT_KEY,
  ingestPoint: env.NEXT_PUBLIC_OPENREPLAY_INGEST_POINT,
  inlineCss: 3,
  // Use only for Emotion/MUI or similar CSS-in-JS replay gaps:
  // css: { scanInMemoryCSS: true, checkCssInterval: 200, checkLimit: 50 },
});
```

Use `inlineCss: 0` or omit `inlineCss` only when you can prove backend asset caching works for that deployment class.

### Custom events

OpenReplay has two custom-event channels:

- Functional events via `tracker.event(name, payload)`. These are indexed and become filters in omnisearch.
- Technical events via `tracker.issue(name, payload)`. These appear in DevTools/session replay and can be used to correlate conversion drops with technical issues.

Use the same dot-delimited taxonomy for both. Prefer:

```ts
tracker.event("checkout.started", { source: "badge-page" });
tracker.event("email.confirmation.sent", { template: "order-confirmation" });
tracker.issue("auth.client.error", { surface: "login" });
```

Avoid copying OpenReplay doc examples such as `product_added` or `payment_error` literally. They demonstrate API shape, not this fleet's naming canon.

### Environment keys

Use these names by platform:

| Platform | Project key env | Ingest point env |
| --- | --- | --- |
| Next.js | `NEXT_PUBLIC_OPENREPLAY_PROJECT_KEY` | `NEXT_PUBLIC_OPENREPLAY_INGEST_POINT` |
| Expo | `EXPO_PUBLIC_OPENREPLAY_PROJECT_KEY` | `EXPO_PUBLIC_OPENREPLAY_INGEST_POINT` |

The project key is client-visible by design. Server-only OpenReplay credentials, if introduced later, must not use `NEXT_PUBLIC_` or `EXPO_PUBLIC_`.

### Event names

OpenReplay custom events should use the same event taxonomy as server logs. Do not create a parallel analytics-only vocabulary.

Good:

```ts
trackEvent("auth.client.error", { surface: "login" });
trackEvent("booking.started", { serviceName });
trackEvent("chat.opened");
```

Avoid:

```ts
trackEvent("booking_started");
trackEvent("socket:connected");
```

## OTel conventions

- Set `service.name` to `<short-project>-<component>`.
- Set deployment environment to the canonical `environment` value.
- Use business attributes with dot names, e.g. `email.template`, `email.recipient_count`, `checkout.order_id`.
- Keep trace/log correlation fields as `traceId` and `spanId` in structured logs unless a collector transform emits vendor-specific aliases.

## Verification checklist

When adding or changing observability wiring:

1. Confirm the project label uses the repo slug.
2. Confirm service names use `<short-project>-<component>`.
3. Confirm environment is one of the four canonical values.
4. Confirm new event names are dot-delimited.
5. If touching legacy events, bridge old and new names in queries.
6. For Grafana/Loki, run a bounded query and report only status/counts/labels.
7. For OpenReplay, verify the provider no-ops when project key is absent and starts only when the key is present.
8. For OpenReplay replay fidelity, verify a sampled replay renders CSS/fonts/icons or document why `inlineCss: 3`/`resourceBaseHref` is needed.
9. Ensure logs and telemetry artifacts do not contain raw tokens, Authorization headers, cookies, email addresses, or session payloads.

## Where this should live

This reference is the human-readable source of truth. The `priceless-observability` skill is the operational entry point for agents and should stay thin. If a project needs local deviations, document them in that project's observability spec and link back here rather than forking the vocabulary.
