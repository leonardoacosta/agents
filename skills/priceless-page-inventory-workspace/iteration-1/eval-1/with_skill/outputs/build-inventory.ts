#!/usr/bin/env tsx
import { mkdirSync, readdirSync, writeFileSync } from "node:fs";
import { join, relative, resolve, sep } from "node:path";
interface InventoryEntry { route: string; file: string; actions: []; view_access: { allow: ["anonymous"]; deny_default: false }; }
const repoRoot = resolve(process.env.INVENTORY_REPO_ROOT ?? ".");
const appDir = resolve(repoRoot, process.env.INVENTORY_APP_DIR ?? "apps/nextjs/src/app");
const outputPath = resolve(repoRoot, process.env.INVENTORY_OUTPUT ?? "packages/inventory/pages.json");
function toRoute(filePath: string): string {
  let route = relative(appDir, filePath).replaceAll(sep, "/").replace(/\/page\.(tsx|ts|jsx|js)$/, "");
  route = route.split("/").filter((s) => !/^\([^/]+\)$/.test(s)).join("/");
  route = route.replace(/\[\.\.\.([^\]]+)\]/g, "*$1").replace(/\[\[\.\.\.([^\]]+)\]\]/g, "*$1").replace(/\[([^\]]+)\]/g, ":$1");
  const normalized = route.replace(/^\/+|\/+$/g, "");
  return normalized ? `/${normalized}` : "/";
}
function walk(dir: string): string[] {
  const pages: string[] = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) pages.push(...walk(full));
    else if (/^page\.(tsx|ts|jsx|js)$/.test(entry.name)) pages.push(full);
  }
  return pages;
}
try { readdirSync(appDir); } catch { throw new Error(`App Router directory not found: ${appDir}`); }
const pages: InventoryEntry[] = walk(appDir).map((filePath) => ({ route: toRoute(filePath), file: relative(repoRoot, filePath).replaceAll(sep, "/"), actions: [], view_access: { allow: ["anonymous"], deny_default: false } })).sort((a, b) => a.route.localeCompare(b.route));
mkdirSync(resolve(outputPath, ".."), { recursive: true });
writeFileSync(outputPath, `${JSON.stringify(pages, null, 2)}\n`);
console.log(`[inventory] wrote ${pages.length} pages to ${outputPath}`);
