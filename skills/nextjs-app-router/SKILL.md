---
name: nextjs-app-router
description: Next.js 15 App Router patterns including route handlers, streaming, Server Actions, caching strategies, and middleware. Use when building Next.js pages, implementing data fetching, configuring middleware, debugging stale data, migrating from Next.js 14 to 15 (async params), or diagnosing caching issues (fetch cache, ISR, Router Cache, unstable_cache).
source: ~/.agents/skills@2026-07-13
user-invocable: false
paths: ["apps/*/src/app/**"]
---


# Next.js 15 App Router Patterns

> Covers App Router-specific patterns for Next.js 15, React 19, TypeScript, Tailwind, tRPC, Better Auth, Vercel.
> This skill fills the gap left by `react-dev` — focus here is on routing, caching, and server/client boundaries.

## Data Fetching Hierarchy

The mental model: **where data lives determines how you fetch it.**

| Layer | Pattern |
|-------|---------|
| Server Component | `await fetch()` or `await createCaller(ctx).router.procedure()` directly |
| Client Component | tRPC React Query hooks (`trpc.router.procedure.useQuery()`) |
| Layout | Fetch shared data once (session, org context); pass via React Context or props |
| `cache()` from React | Deduplicate identical fetches within a single request — NOT across requests |

```typescript
// Server Component — fetch directly, no hooks
export default async function ProductPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;  // Next.js 15: params is a Promise
  const product = await db.query.product.findFirst({ where: eq(schema.product.id, id) });
  return <ProductView product={product} />;
}

// Deduplicate within a request using cache()
import { cache } from "react";
export const getSession = cache(async () => auth());
```

### Stale Data Triage

Data looks stale? Work through this:

```
Data not updating?
├── Server Component with fetch()?
│   └── fetch() is cached indefinitely by default
│       Fix: { cache: "no-store" } or { next: { revalidate: N } }
├── Page on Vercel showing old content?
│   └── Vercel ISR caches pages for 30s by default
│       Fix: export const revalidate = 0; at top of page
├── tRPC query returning old data?
│   └── React Query staleTime or gcTime too high
│       Fix: staleTime: 0 for real-time data
├── Mutated data not reflected?
│   └── Missing revalidation after Server Action
│       Fix: revalidatePath() or revalidateTag() after mutation
└── unstable_cache returning stale results?
    └── Tag not invalidated
        Fix: revalidateTag("your-tag") in Server Action
```

## Streaming + Suspense

- Wrap slow data in `<Suspense fallback={<Skeleton />}>` — never block the full page on slow queries
- `loading.tsx` is an implicit Suspense boundary for the entire route segment
- Never `await` independent fetches sequentially — fan out with `Promise.all()`
- Use the `use()` hook (React 19) to consume a promise passed from a Server Component into a Client Component

```typescript
// Parallel fetches — not sequential
const [user, orders] = await Promise.all([getUser(id), getOrders(id)]);

// Streaming slow data
export default function Page() {
  return (
    <>
      <FastSection />
      <Suspense fallback={<OrdersSkeleton />}>
        <SlowOrdersSection />
      </Suspense>
    </>
  );
}

// React 19 use() in Client Component
"use client";
import { use } from "react";
export function UserCard({ userPromise }: { userPromise: Promise<User> }) {
  const user = use(userPromise);  // Suspends until resolved
  return <div>{user.name}</div>;
}
```

### Client-component layouts kill RSC SSR + prefetch (gotcha)

A `"use client"` layout — or one that gates `{children}` behind client-only state (e.g. `const [ctx] = useState(null)` populated in a `useEffect` after a query resolves) — renders a fallback during SSR and **never renders `{children}` server-side**. This silently defeats RSC server rendering AND prefetch for the *entire* subtree below it:

- **Nothing in the subtree appears in the raw SSR HTML.** The layout streams its spinner/fallback; children render only after client hydration + the gate resolves. A `page.request.get()` (or any no-JS fetch) sees only the gate. Asserting "content X is in the initial HTML" for a gated route is structurally impossible.
- **`prefetch` + `HydrateClient` still ship settled data** in the Flight/dehydrated payload (the prefetch itself works — the key hashes correctly, status is `success`), but the island never renders server-side, so the data is invisible until the client mounts it.
- **Hydration is deferred to the client (post-gate), so it races the island.** A `useSuspenseQuery`/`useQuery` observer can subscribe *before* the dehydrated cache hydrates → one stray first-paint refetch, defeating "zero client refetch." `refetchOnMount: false` alone does NOT fully close it; you also need `initialData` (or `staleTime: Infinity`) on the first-paint read.

**Tell:** prefetch looks correct (settled entry in the payload, matching queryKey) yet the feed is absent from raw SSR HTML and refetches once on load — and the same symptom appears on *every* route under that layout, not just one.

**Fix for true RSC SSR + zero-refetch:** make the layout a **server component** — resolve the gating data server-side (e.g. read the scope from a cookie/header in the RSC) so children render and hydrate on the server. If the layout must stay client-gated, the achievable invariant is "prefetch ships settled + island consumes cache with no *extra* network," not "content in raw HTML."

> Evidence: a production RSC-prefetch pilot found an `(auth)/layout.tsx` with `"use client"`
> gating on client-only scope state. Every nested route rendered only a loading fallback in raw
> SSR; the prefetch shipped settled data, but the island never server-rendered and raced hydration.
> Decoding the deployed dehydrated state isolated the client gate as the cause.

## Route Organization

| Pattern | Syntax | Use When |
|---------|--------|----------|
| Route group | `(auth)/login` | Share a layout without adding URL segment |
| Parallel route | `@modal/default.tsx` | Render multiple views in the same layout slot |
| Intercepting route | `(.)photo/[id]` | Modal overlay that shows a page inline |

- **Route groups vs separate layouts**: groups share a layout; separate directories get independent layouts.
- `(.)` intercepts same level, `(..)` parent level, `(...)` root level.

```
app/
  (dashboard)/
    layout.tsx        ← shared dashboard shell
    overview/page.tsx
    settings/page.tsx
  (auth)/
    layout.tsx        ← minimal auth shell
    login/page.tsx
  @modal/
    (.)photo/[id]/page.tsx  ← intercepted modal
```

### Shared route chrome belongs in layout.tsx, not per-page (gotcha)

Tabs, section headers, and filter toolbars that are constant across a group of sibling routes MUST live in the group's `layout.tsx`, wrapping `{children}`. App Router preserves the `layout` instance across intra-group navigation and swaps only the `page` slot — so chrome in the layout stays mounted, while chrome rendered *inside* each `page.tsx` **remounts on every navigation**.

**Tell:** route-based tabs (`<Link>` + `usePathname`) where clicking a tab visibly re-renders the whole surrounding card — header, filter bar, and any queries the toolbar fires flash/refetch — instead of only the content under the tabs. The give-away in code is the same chrome component imported into 2+ sibling `page.tsx` files.

```tsx
// ❌ header remounts on every tab click — it's in the page
// list-view/page.tsx, my-shifts/page.tsx, ... each do:
export default function Page() {
  return <SectionHeader>{/* tab body */}</SectionHeader>;
}

// ✅ header persists; only the body swaps — it's in the layout
// layout.tsx
export default function Layout({ children }: { children: ReactNode }) {
  return <SectionHeader>{children}</SectionHeader>;
}
// list-view/page.tsx → returns only its body
```

A `"use client"` chrome component (needs `usePathname` for the active-tab state) wraps RSC `{children}` in a layout fine — the children still stream server-side. Also trim the group's `loading.tsx` to a **body-only** skeleton: it fills the `page` Suspense slot *inside* the persistent layout, so a header skeleton there double-renders the real header.

> Evidence: in a production route group, a shared section header rendered inside every page,
> causing each tab click to remount the card and re-fire toolbar queries. Moving the shared
> chrome to `layout.tsx` preserved it across sibling-route navigation.

### Next.js 15 Async Params

In Next.js 15, `params` and `searchParams` are now `Promise` — this is the #1 TypeScript migration gotcha:

```typescript
// Next.js 14 pattern — breaks in 15
export default function Page({ params }: { params: { id: string } }) {
  return <div>{params.id}</div>;  // TS error: params is Promise
}

// Next.js 15 — await params
export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <div>{id}</div>;
}

// Client component — use React.use()
"use client";
import { use } from "react";
export default function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  return <div>{id}</div>;
}
```

Same applies to `searchParams` in page components and `generateMetadata`.

## Server Actions

`"use server"` at the top of a file is preferred over inline — promotes reuse across components.

```typescript
// app/actions/cart.ts
"use server";
import { z } from "zod";
import { revalidatePath } from "next/cache";

const AddItemSchema = z.object({ productId: z.string(), qty: z.number().min(1) });

export async function addToCart(input: unknown) {
  const parsed = AddItemSchema.safeParse(input);  // ALWAYS validate — client can send anything
  if (!parsed.success) return { error: "Invalid input" };

  await db.insert(schema.cartItem).values({ ...parsed.data, userId: session.user.id });
  revalidatePath("/cart");  // Bust the cache for /cart
  // return { error: "..." } on failure — don't throw (unhandled = 500 page)
}
```

- After mutation: `revalidatePath("/route")` or `revalidateTag("tag")` to invalidate cached data
- Server Actions run on the server even when called from a Client Component
- Return `{ error: string }` for handled failures — only throw for truly unexpected errors

## Caching Gotchas

The most common source of stale-data bugs in App Router:

| Behavior | Default | Override |
|----------|---------|----------|
| `fetch()` in Server Component | Cached indefinitely | `{ cache: "no-store" }` or `{ next: { revalidate: 60 } }` |
| Page on Vercel | Cached 30s (ISR) | `export const revalidate = 0` at top of page file |
| DB query via tRPC/Drizzle | Not cached | `unstable_cache()` with a tag |

**Dynamic rendering is triggered automatically by:** `cookies()`, `headers()`, `searchParams` prop, `noStore()`.

```typescript
// Opt page out of Vercel edge cache
export const revalidate = 0;

// Cache an expensive DB query with manual invalidation
import { unstable_cache } from "next/cache";

const getCachedProducts = unstable_cache(
  async () => db.query.product.findMany(),
  ["products"],
  { tags: ["products"], revalidate: 3600 }
);

// Invalidate from a Server Action
import { revalidateTag } from "next/cache";
revalidateTag("products");
```

### revalidatePath vs revalidateTag

| Use | When |
|-----|------|
| `revalidatePath("/products")` | Only `/products` page shows this data |
| `revalidatePath("/", "layout")` | Blow away ALL cached data (nuclear option) |
| `revalidateTag("products")` | Multiple routes display product data (`/products`, `/dashboard`, `/search`) |

**Rule of thumb:** If the data appears on >1 route, use tags. Tags are cheaper (invalidate specific cache entries) vs path (re-renders entire route segment).

## Better Auth + App Router

```typescript
// Server Component or Server Action — synchronous, no await
import { auth } from "@/lib/auth";
const session = auth();
if (!session) redirect("/login");

// Pass only needed fields to Client Components — never full session
<ClientComponent userId={session.user.id} role={session.user.role} />
```

- **Bulk route protection**: `middleware.ts` — runs at edge before render
- **Per-route logic**: layout-level `auth()` check with `redirect()`
- Never expose session tokens or full user objects to Client Components — they ship to the browser

```typescript
// middleware.ts — protect all /dashboard/* routes
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(req: NextRequest) {
  const token = req.cookies.get("session")?.value;
  if (!token && req.nextUrl.pathname.startsWith("/dashboard")) {
    return NextResponse.redirect(new URL("/login", req.url));
  }
}
export const config = { matcher: ["/dashboard/:path*"] };
```

### Auth Strategy Decision

```
Protecting routes?
├── Bulk route protection (all /dashboard/*)?
│   └── middleware.ts — runs at edge, before any rendering
├── Per-page with different logic per role?
│   └── Layout-level auth() check + redirect()
├── Protecting a Server Action?
│   └── auth() check inside the action — middleware doesn't cover actions
└── Protecting an API route handler?
    └── auth() check inside the handler — same as Server Actions
```

## Never Do This

- **NEVER** use `useEffect` for initial data fetching — **WHY:** Server Components fetch data during render with zero client JS. useEffect fetches AFTER hydration, causing a loading flash and doubling time-to-data.
- **NEVER** `await` sequential independent fetches — **WHY:** `const a = await getA(); const b = await getB();` takes `timeA + timeB`. `Promise.all([getA(), getB()])` takes `max(timeA, timeB)`.
- **NEVER** put secrets in Client Components — **WHY:** `"use client"` components ship their entire module to the browser. Environment variables, API keys, and session tokens become visible in the JS bundle.
- **NEVER** use `{ params }` without `await` in Next.js 15 — **WHY:** `params` is now a `Promise`. Accessing `.id` directly gives `undefined` or a TS error. Always `const { id } = await params;` in Server Components or `use(params)` in Client Components.
- **NEVER** assume `fetch()` returns fresh data — **WHY:** App Router caches ALL `fetch()` calls indefinitely by default. This is the #1 source of "my data is stale" bugs. Use `{ cache: "no-store" }` for real-time data.
- **NEVER** use `revalidatePath("/", "layout")` as a default — **WHY:** It invalidates ALL cached data across ALL routes. Use targeted `revalidateTag()` for specific data, or `revalidatePath("/specific-route")` for one page.
- **NEVER** mix `"use server"` and `"use client"` in the same file — **WHY:** A file is either a Server Module or Client Module. Mixing directives is a build error.

## View Transitions

Opt in via `next.config.ts` (experimental flag, Next.js 16+):

```ts
const nextConfig: NextConfig = {
  experimental: { viewTransition: true },
}
```

Then import `ViewTransition` from React 19:

```tsx
import { ViewTransition } from 'react'
```

Animations only fire inside React Transitions (`useTransition`, `<Suspense>`, `useDeferredValue`). Route navigations in Next.js are already Transitions — `<ViewTransition>` activates automatically during `<Link>` clicks.

### Four canonical patterns

| Pattern | How | What it communicates |
|---|---|---|
| Shared element morph | Same `name` prop on both pages | "Same object, different view" |
| Suspense reveal | `exit` on skeleton, `enter` on content | "Data loaded" |
| Directional navigation | `transitionTypes` on `<Link>` + mapped `enter`/`exit` props | "Going forward / going back" |
| Same-route crossfade | Change `key` on `<ViewTransition name="…" share="auto">` | "Same place, different content" |

```tsx
// Shared element morph — wrap matching elements on both pages with same name
<ViewTransition name={`photo-${photo.id}`}>
  <Image src={photo.src} alt={photo.title} />
</ViewTransition>

// Directional navigation — tag links with a type
<Link href={`/photo/${id}`} transitionTypes={['nav-forward']}>…</Link>
<Link href="/" transitionTypes={['nav-back']}>…</Link>

// Map types to CSS class names on the receiving page
<ViewTransition
  enter={{ 'nav-forward': 'nav-forward', 'nav-back': 'nav-back', default: 'none' }}
  exit={{ 'nav-forward': 'nav-forward', 'nav-back': 'nav-back', default: 'none' }}
  default="none"
>
  {/* page content */}
</ViewTransition>
```

CSS targets `::view-transition-old(.class)` / `::view-transition-new(.class)` / `::view-transition-group(.class)`.

**Always add a reduced-motion guard:**

```css
@media (prefers-reduced-motion: reduce) {
  ::view-transition-old(*), ::view-transition-new(*), ::view-transition-group(*) {
    animation-duration: 0s !important;
    animation-delay: 0s !important;
  }
}
```

**Caveats:**
- Browser back/swipe gestures do NOT carry `transitionTypes` — shared element morph still applies
- `useRouter().push()` and `.replace()` also accept `transitionTypes`
- Without browser support the app works normally (progressive enhancement)
- Safari may animate differently for some patterns

See also: `motion-and-transitions` skill for component-local CSS transitions (modals, dropdowns, badges).

## References

**MANDATORY** — load when debugging stale data or building data-fetching pages:
- [caching-gotchas.md](references/caching-gotchas.md) — extended caching traps with examples

**Do NOT load** for purely client-side component work (forms, modals, state) — use react-dev skill instead.
