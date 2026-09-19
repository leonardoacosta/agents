# Page Inventory — Schema and Build Script

## Schema (`packages/inventory/src/types.ts`)

The schema defines three interfaces:

- **`ActionInventory`**: tRPC procedure path, required permissions, CRUD type, security_critical flag, escalation flag, side-effects
- **`ViewAccess`**: Which persona keys can access the page (`allow` array), and whether to deny all others (`deny_default`)
- **`PageInventoryEntry`**: Route path, source file, actions array, view_access

Full types saved to `packages/inventory/src/types.ts`.

## Build Script (`scripts/build-inventory.ts`)

Walks `apps/nextjs/src/app/**/page.tsx`, derives canonical routes from the file path, handles:
- Route groups: `(group)` directories are stripped
- Dynamic segments: `[id]` → `:id`
- Catch-all params: `[...slug]` → `*slug`

Output: `packages/inventory/pages.json` with route, file, placeholder actions, and default public access.

## Monorepo Wiring

Add to root `package.json`:
```json
"scripts": {
  "inventory:build": "tsx scripts/build-inventory.ts"
}
```

## Next Steps

After running the script, populate `actions` and `view_access` per module file:
1. Create `packages/inventory/src/pages/public.ts`, `staff-finance.ts`, etc.
2. For each page, fill in the procedures, permissions, and who can access it
3. Barrel-export all modules as `PAGES` from `packages/inventory/src/index.ts`

The categorization pipeline (`priceless-test-categorization`) will then consume `PAGES` via `import { PAGES } from "@oo/inventory"`.