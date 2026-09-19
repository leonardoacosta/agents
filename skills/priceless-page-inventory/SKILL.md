---
name: priceless-page-inventory
description: >
  Lightweight page-inventory schema and Next.js build script. Use whenever the
  user asks to inventory pages, build a page registry, catalog routes, enumerate
  app surfaces, create an inventory, map pages to permissions, or set up a
  test-inventory contract. Apply this skill before any test categorization or
  Jev triage work — the inventory contract is a prerequisite.
allowed-tools: Read, Glob, Grep, Bash, Write
---

# Priceless Page Inventory

A page inventory answers: which routes exist, what actions each page exposes, who can access them, and which procedures back them. Categorization and triage skills consume this contract — without it, test analysis has no page-level ceilings, persona coverage checks, or action-sensitivity scoring.

This skill is **lightweight**: it defines the schema, provides a `build-inventory.ts` script for Next.js App Router projects, and explains how to wire it into a monorepo. It does not try to auto-discover or reverse-engineer an inventory from scratch.

## Schema

```typescript
// packages/inventory/src/types.ts (or equivalent)

export interface ActionInventory {
  /** dot-notation tRPC procedure path, e.g. "badges.approve" */
  procedure?: string;
  /** Permissions required to invoke this action */
  requires?: Record<string, string[]>;
  /** CRUD classification: "C"reate, "R"ead, "U"pdate, "D"elete, "Bulk" */
  crud?: string;
  /** Security-critical actions must have E2E coverage */
  security_critical?: boolean;
  /** Escalation actions may skip E2E if Vitest-integration covered */
  escalation?: boolean;
  /** Side-effect tags: stripe_checkout, stripe_refund, resend_email, etc. */
  side_effects?: string[];
}

export interface ViewAccess {
  /** Persona keys that may access this page. "anonymous" = no auth required. */
  allow: string[];
  /** If true, deny access to all personas not in `allow`. Default false. */
  deny_default: boolean;
}

export interface PageInventoryEntry {
  /** Canonical route path, e.g. "/staff/sales/badges" */
  route: string;
  /** Source file relative to repo root, e.g. "apps/nextjs/src/app/(staff)/staff/sales/badges/page.tsx" */
  file: string;
  /** Actions surfaced on this page */
  actions: ActionInventory[];
  /** Who can see this page */
  view_access: ViewAccess;
}

/** The complete inventory — one entry per Next.js App Router page. */
export type PageInventory = PageInventoryEntry[];
```

## Next.js build script

Drop `scripts/build-inventory.ts` into any Next.js App Router project. It walks `apps/nextjs/src/app/**/page.tsx`, derives the canonical route from the file path (handling `(group)`, `[param]`, `[...slug]` segments), and writes a typed inventory JSON. Run it before test categorization.

```typescript
#!/usr/bin/env tsx
import { readdirSync, statSync, writeFileSync } from "node:fs";
import { basename, dirname, join, relative, resolve } from "node:path";

interface InventoryEntry {
  route: string;
  file: string;
  actions: { procedure?: string }[];
  view_access: { allow: string[]; deny_default: boolean };
}

const appDir = resolve("apps/nextjs/src/app");
const outputPath = resolve("packages/inventory/pages.json");

function toRoute(filePath: string): string {
  let route = filePath
    .replace(appDir, "")
    .replace(/\/page\.(tsx|ts|jsx|js)$/, "")
    .replace(/\/layout\.(tsx|ts)$/, "") || "/";
  // Strip route groups: (group)
  route = route.replace(/\/\([^)]+\)/g, "");
  // Normalize dynamic segments: [id] -> :id
  route = route.replace(/\[([^\]]+)\]/g, ":$1");
  // Remove catch-all prefix: [...slug] -> *slug
  route = route.replace(/\[\.\.\.([^\]]+)\]/g, "*$1");
  // Collapse repeated slashes and trailing slash
  route = route.replace(/\/+/g, "/").replace(/\/$/, "") || "/";
  return route;
}

function walkPages(): InventoryEntry[] {
  const entries: InventoryEntry[] = [];
  function walk(dir: string): void {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.name === "page.tsx" || entry.name === "page.ts") {
        const route = toRoute(full);
        const file = relative(resolve("."), full);
        entries.push({
          route,
          file,
          actions: [],
          view_access: { allow: ["anonymous"], deny_default: false },
        });
      }
    }
  }
  walk(appDir);
  return entries.sort((a, b) => a.route.localeCompare(b.route));
}

const pages = walkPages();
writeFileSync(outputPath, JSON.stringify(pages, null, 2));
console.log(`[inventory] wrote ${pages.length} pages to ${outputPath}`);
```

**Monorepo wiring**: Add to root `package.json`:

```json
{
  "scripts": {
    "inventory:build": "tsx scripts/build-inventory.ts"
  }
}
```

Or, if the inventory package already exists:

```json
{
  "scripts": {
    "build:inventory": "pnpm --filter @oo/inventory build:inventory"
  }
}
```

## Populating actions and view_access

The build script produces route + file paths. Actions and view_access are manual per-module. Create one module file per logical domain under `packages/inventory/src/pages/`:

```typescript
// packages/inventory/src/pages/public.ts
import type { PageInventoryEntry } from "../types";

export const publicPages: PageInventoryEntry[] = [
  {
    route: "/",
    file: "apps/nextjs/src/app/page.tsx",
    actions: [],
    view_access: { allow: ["anonymous"], deny_default: false },
  },
  // ... each public page
];
```

Then barrel-export `PAGES`:

```typescript
// packages/inventory/src/index.ts
import { publicPages } from "./pages/public";
import { authPages } from "./pages/auth";
// ... all modules

export const PAGES = [
  ...publicPages,
  ...authPages,
  // ... all modules
].sort((a, b) => a.route.localeCompare(b.route));
```

## Expected output

A project using this contract produces a typed `PAGES: PageInventoryEntry[]` export that categorization and triage skills consume via `import { PAGES } from "@oo/inventory"` or equivalent. Each entry must have:

- `route`: canonical path
- `file`: source location
- `actions[].procedure`: dot-notation tRPC path (if backend-driven)
- `actions[].requires`: permission object (if gated)
- `actions[].security_critical`: boolean (if destructive or Stripe-touching)
- `view_access.allow`: persona keys that can see this page