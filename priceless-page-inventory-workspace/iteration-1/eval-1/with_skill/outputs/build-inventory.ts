#!/usr/bin/env tsx
import { readdirSync, writeFileSync } from "node:fs";
import { join, relative, resolve } from "node:path";

interface InventoryEntry {
  route: string;
  file: string;
  actions: { procedure?: string }[];
  view_access: { allow: string[]; deny_default: boolean };
}

// Adaptable app directory — change this for different project layouts
const appDir = resolve("apps/web/src/app");
const outputPath = resolve("packages/inventory/pages.json");

function toRoute(filePath: string): string {
  let route = filePath
    .replace(appDir, "")
    .replace(/\/page\.(tsx|ts|jsx|js)$/, "")
    .replace(/\/layout\.(tsx|ts)$/, "") || "/";
  route = route.replace(/\/\([^)]+\)/g, "");
  route = route.replace(/\[([^\]]+)\]/g, ":$1");
  route = route.replace(/\[\.\.\.([^\]]+)\]/g, "*$1");
  route = route.replace(/\/+/g, "/").replace(/\/$/, "") || "/";
  return route;
}

// Same walk logic as before
function walkPages(): InventoryEntry[] {
  const entries: InventoryEntry[] = [];
  function walk(dir: string): void {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (entry.name === "page.tsx" || entry.name === "page.ts") {
        entries.push({
          route: toRoute(full),
          file: relative(resolve("."), full),
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