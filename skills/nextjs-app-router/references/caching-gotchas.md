
# Caching Gotchas — Extended Reference

## The 5 Caching Layers

Next.js App Router has 5 independent caching layers. Each can serve stale data independently:

| Layer | Scope | Default | Invalidation |
|-------|-------|---------|--------------|
| **React cache()** | Per-request | Deduplicates within single render | Automatic (request-scoped) |
| **fetch() cache** | Across requests | Cached indefinitely | `revalidate: N`, `cache: "no-store"`, `revalidateTag()` |
| **Full Route Cache** | Vercel edge | Static pages cached at build | `revalidatePath()`, `revalidateTag()`, `export const revalidate = 0` |
| **Router Cache** | Client browser | 30s dynamic, 5min static | `router.refresh()`, navigation, `revalidatePath()` from Server Action |
| **unstable_cache** | Server process | Until explicitly invalidated | `revalidateTag("tag")` |

## Common Traps

### Trap 1: fetch() caches by default
```typescript
// This response is cached FOREVER until you redeploy
const res = await fetch("https://api.example.com/data");

// Fix: opt out of caching
const res = await fetch("https://api.example.com/data", { cache: "no-store" });

// Fix: time-based revalidation (60 seconds)
const res = await fetch("https://api.example.com/data", { next: { revalidate: 60 } });
```

### Trap 2: Vercel ISR serves stale pages
```typescript
// Page is cached for 30s on Vercel, even with fresh DB queries
export default async function ProductsPage() {
  const products = await db.query.product.findMany(); // Fresh query...
  return <ProductList products={products} />;          // ...but Vercel serves cached HTML
}

// Fix: opt out of ISR for this page
export const revalidate = 0;
// or use dynamic rendering triggers: cookies(), headers(), searchParams
```

### Trap 3: Router Cache shows old data after navigation
```typescript
// User navigates /products -> /products/123 -> back to /products
// Products page shows cached version, not fresh data!

// Fix 1: In Server Action after mutation
"use server";
export async function deleteProduct(id: string) {
  await db.delete(product).where(eq(product.id, id));
  revalidatePath("/products");  // Busts both server AND client cache
}

// Fix 2: Client-side forced refresh
router.refresh();  // Refetches current route from server
```

### Trap 4: unstable_cache without tags
```typescript
// Cached forever — no way to invalidate!
const getProducts = unstable_cache(async () => db.query.product.findMany());

// Fix: always add tags
const getProducts = unstable_cache(
  async () => db.query.product.findMany(),
  ["products"],          // cache key
  { tags: ["products"], revalidate: 3600 }  // tag + TTL
);

// Invalidate from Server Action
revalidateTag("products");
```

### Trap 5: React.cache() doesn't cache across requests
```typescript
// This only deduplicates within a SINGLE request/render
import { cache } from "react";
const getUser = cache(async (id: string) => fetchUser(id));

// Request 1: getUser("123") -> fetches from DB
// Request 1: getUser("123") -> returns cached (same request!)
// Request 2: getUser("123") -> fetches from DB again (new request!)

// For cross-request caching, use unstable_cache:
const getUser = unstable_cache(
  async (id: string) => fetchUser(id),
  ["user"],
  { tags: [`user-${id}`], revalidate: 300 }
);
```

## Decision: Which Cache to Use

```
Need to cache?
├── Same data used by multiple components in one render?
│   └── React.cache() — per-request dedup, automatic cleanup
├── Same data across multiple user requests?
│   ├── External API with fetch()? -> { next: { revalidate: N, tags: [...] } }
│   └── DB query via ORM? -> unstable_cache with tags + TTL
├── Entire page rarely changes?
│   └── export const revalidate = 3600; (ISR)
└── Data must always be fresh?
    └── No caching: { cache: "no-store" } or export const revalidate = 0;
```
