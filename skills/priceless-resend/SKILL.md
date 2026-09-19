---
name: priceless-resend
description: Priceless fleet guidance for integrating, debugging, verifying, and operating Resend transactional email in production. Use whenever a Priceless project sends purchase confirmations, receipts, QR codes, staff notifications, or other email through Resend, especially when a user reports missing emails, `missing_api_key`, unauthorized requests, idempotency behavior, Vercel environment-variable confusion, webhook delivery failures, or asks to inspect Vercel and Resend logs. Prefer this skill before changing secrets or redeploying, and use it for end-to-end proof from application logs through Resend message delivery.
metadata:
  evaluated:
    claude: {at: "2026-08-09T15:13:05Z", score: unmeasured, note: "trigger harness timed out at 90s and 180s"}
    codex: null
    cursor: null
    jscode: null
    pi: null
---

# Priceless Resend

Use this skill for production email work in Priceless projects. The goal is not merely to make an SDK call succeed. Prove the complete path:

`checkout or business event -> webhook/handler -> Resend request -> accepted message -> delivered message`

Protect secrets throughout. Never print, commit, paste, or echo a Resend API key, sender credential, Stripe secret, or full environment file.

## First response to a missing email

1. Identify the exact event and environment.
   - Project and deployment
   - Production, preview, or local
   - Recipient, subject, approximate UTC time, and idempotency key if available
2. Pull application evidence from Vercel logs around the event.
   - Confirm the webhook or handler ran.
   - Look for structured email diagnostics, provider response codes, message IDs, and error names.
3. Check Resend using a redacted or API-backed query.
   - A successful HTTP request is not enough. Confirm the message ID and final event, ideally `delivered`.
4. Check health endpoints or provider diagnostics if the project has them.
5. Only then change environment variables or redeploy.

## Earned root cause: Resend header replacement

Resend SDK v3.5.0 puts the API key into default authorization headers when constructing `new Resend(apiKey)`. In that SDK, passing request options with a `headers` object can replace the SDK defaults rather than merge them.

This is unsafe:

```ts
client.emails.send(payload, {
  headers: { "Idempotency-Key": idempotencyKey },
});
```

The request may omit:

```http
Authorization: Bearer <resend-api-key>
```

Resend then returns `missing_api_key`, even when the Vercel secret exists and is valid.

### Required implementation pattern

If per-request headers are needed, preserve authorization explicitly and merge the request headers:

```ts
const headers = {
  Authorization: `Bearer ${apiKey}`,
  ...(options?.headers ?? {}),
};

return resend.emails.send(payload, { ...options, headers });
```

Keep the merge at the project’s email-client boundary so every call path, including `emails.send` and `batch.send`, gets the same behavior. Preserve idempotency headers because retries and webhook redelivery must not create duplicate messages.

Before applying this fix, inspect the installed Resend SDK source or type definitions. Do not assume a newer SDK version has the same merge semantics.

## Runtime environment variables on Vercel

A build-time environment read can be stale or absent when values are changed after deployment. For production email configuration:

- Read the value at request/runtime execution, not only at module initialization during a build.
- Treat empty strings as missing and trim values before use.
- Use the project’s supported runtime environment accessor if one exists.
- Do not log the value. Log only safe metadata such as `configured: true`, source name, or key prefix if policy explicitly permits it.
- After changing a production variable, redeploy the application. Existing serverless artifacts do not reliably pick up changed values without a new deployment.

Never solve uncertainty by exposing plaintext secrets in chat or logs. If a value must be checked, validate presence, length, prefix shape, or authorization through a controlled API call, then redact the result.

## Verification matrix

Run the narrowest checks first, then expand:

### Local and static checks

- Email client and provider unit tests
- Idempotency and header-merging tests
- Template and QR generation tests
- API package typecheck
- Build using the project’s supported Node version and memory settings

At minimum, add or confirm a regression test that proves a request with `Idempotency-Key` still contains `Authorization`.

### Production integration checks

Use a safe test recipient and a valid zero-dollar or fully discounted checkout when available. Do not enter payment details unless the user explicitly authorizes it and the payment flow requires it.

Confirm all of the following:

1. The checkout or business event succeeds.
2. The production webhook reaches the intended production deployment.
3. Vercel logs show the handler and email send without an auth or provider error.
4. The response contains a Resend message ID.
5. Resend’s message record shows the expected recipient and subject.
6. The final Resend event is `delivered`, not merely `queued` or `sent`.
7. Health endpoints remain healthy after the test.

If the success redirect points at a non-production host while the webhook reached production, record that separately. Do not confuse redirect configuration with webhook execution or email delivery.

## Failure classification

- `missing_api_key` with a configured Vercel secret: inspect request header replacement before rotating secrets.
- `401` or `403`: verify the runtime value is present, non-empty, from the intended environment, and authorized by a safe API probe.
- No Vercel handler log: investigate checkout/webhook routing, signing, deployment aliases, and event delivery before Resend.
- Vercel shows provider success but no Resend message: capture the returned response and message ID, then inspect the exact Resend account and region.
- Resend shows `sent` but not `delivered`: inspect recipient suppression, sender-domain authentication, bounce/complaint events, and recipient mailbox behavior.
- Duplicate confirmations: inspect idempotency-key stability and retry/webhook deduplication.
- Deployment upload limit: use the project’s archive/tgz deployment path and exclude generated directories such as `.next` when the deployment workflow supports it.
- Build OOM: use the repository’s documented heap setting and distinguish build failure from runtime email failure.

## Safe production evidence report

Report with this compact structure:

```text
Environment: production
Deployment: <deployment ID and Ready status>
Trigger: <event and UTC time>
Vercel: <handler observed, error or no error>
Resend: <message ID, recipient redacted if needed, final event>
Health: <provider and application health>
Result: delivered / accepted / blocked / unresolved
Secrets: not printed
```

State clearly when a broader suite has unrelated failures. Do not claim all tests pass if only focused tests passed.
