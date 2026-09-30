# API and client integration

## Four different auth questions

| Surface | What controls it |
| --- | --- |
| Dashboard | Management password/session and dashboard login posture |
| `/v1/models` | Dashboard auth posture, with `requireAuthForModels` override |
| Inference `/v1/chat/completions`, `/v1/responses`, other client API routes | Effective `REQUIRE_API_KEY` feature flag |
| Management `/api/*` | Route policy, session/CSRF, API-key scopes and local-only rules |

Feature flags resolve DB override > environment > default. Inspect the effective value, not just compose or `.env`. A discovery `401` can coexist with anonymous inference. `AUTH_REQUIRED` is not a substitute for `REQUIRE_API_KEY`.

For protection checks, use a bounded no-credential request to the actual inference route with intentionally invalid input, following `docs/security/INFERENCE_AUTH_POSTURE.md`. A protected route should reject auth before accepting inference. A validation error instead of an auth error means the request reached later processing, but does not by itself prove provider success. Never send a billable anonymous request merely to test protection.

Inference accepts Bearer credentials and compatibility headers such as `x-api-key`; management has stricter route-specific rules. Do not put keys in URLs. Dashboard cookie writes can need a CSRF token from `/api/auth/csrf` in `x-omniroute-csrf`. An inference key is not automatically an admin key. Do not log cookies or token responses.

## Discover before calling

`GET /v1/models` returns an OpenAI-style model catalog. `GET /v1` also delegates to the catalog. Capability discovery routes include:

| Capability | Discovery | Request |
| --- | --- | --- |
| Chat | `/v1/models` | `/v1/chat/completions` |
| Responses | `/v1/models` | `/v1/responses` |
| Anthropic messages | `/v1/models` | `/v1/messages` |
| Embeddings | `/v1/models/embedding` | `/v1/embeddings` |
| Images | `/v1/models/image` | `/v1/images/generations` |
| Speech output | `/v1/models/tts` | `/v1/audio/speech` |
| Transcription | `/v1/models/stt` | `/v1/audio/transcriptions` |
| Image-to-text | `/v1/models/image-to-text` | `/v1/image-to-text` |
| Web search/fetch | `/v1/models/web` | `/v1/web/search`, `/v1/web/fetch` |

Endpoint existence does not guarantee every model/provider supports that capability. Read the matching upstream inference skill and route schema before non-chat calls. Do not assume image edits, realtime, batches, or tool semantics work identically on all upstreams. Next.js source paths use `src/app/api/v1`; public clients normally use the rewritten `/v1` paths.

Small chat test after approval:

```bash
# OMNIROUTE_MODEL must be an exact ID returned by this instance.
jq -n --arg model "$OMNIROUTE_MODEL" \
  '{model:$model,messages:[{role:"user",content:"Reply with OK."}],max_tokens:8,stream:false}' |
  curl --fail-with-body --silent --show-error "$OMNIROUTE_BASE_URL/v1/chat/completions" \
    -H "Authorization: Bearer ${OMNIROUTE_API_KEY}" \
    -H 'Content-Type: application/json' --data-binary @-
```

No successful runtime request was made during skill creation. These are source-grounded contracts, not a certification of a running deployment.

## Coding clients

OpenAI-compatible clients: base URL ends in `/v1`, use an OmniRoute-issued key and catalog model ID. Configure only the target client, preserve its prior config, and do not overwrite the user's provider credentials.

Codex's documented provider configuration uses `base_url = "http://localhost:20128/v1"`, `wire_api = "responses"`, and `env_key = "OMNIROUTE_API_KEY"`. Check the installed Codex configuration schema before editing. Upstream `docs/guides/CODEX-CLI-CONFIGURATION.md` is the detailed reference.

For multi-hour Codex tasks, `sessionAffinityTtlMs` defaults to `0` (off). Enabling a TTL can preserve account affinity, but can affect routing and must be deliberate. `STREAM_IDLE_TIMEOUT_MS` defaults to `600000`; `FETCH_BODY_TIMEOUT_MS` is also relevant. Set timeouts from the actual task and proxy limits, not blanket unlimited values.

For Claude Code, Cursor, Cline, Gemini CLI, or OpenCode, consult `docs/reference/CLI-TOOLS.md` and upstream `omni-cli-tools`. Different clients use different protocols, headers, and base URL suffixes. Do not copy one client's settings into another or assume a client-configure endpoint is read-only.
