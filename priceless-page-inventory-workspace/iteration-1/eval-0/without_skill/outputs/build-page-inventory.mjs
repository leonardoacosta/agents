#!/usr/bin/env node
import { promises as fs } from 'node:fs';
import path from 'node:path';

const args = process.argv.slice(2);
const getArg = (name, fallback) => {
  const i = args.indexOf(name);
  return i >= 0 && args[i + 1] ? args[i + 1] : fallback;
};
const appDir = path.resolve(getArg('--app-dir', '/home/nyaptor/dev/my-app/apps/nextjs/app'));
const output = path.resolve(getArg('--output', path.join(process.cwd(), 'page-inventory.json')));
const allowedPageFiles = new Set(['page.js', 'page.jsx', 'page.ts', 'page.tsx', 'page.mjs', 'page.mjsx', 'page.cjs', 'page.cts', 'page.mts', 'page.mtsx']);
const ignoredDirectories = new Set(['node_modules', '.next']);

async function walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    if (entry.isDirectory() && !ignoredDirectories.has(entry.name)) files.push(...await walk(path.join(dir, entry.name)));
    else if (entry.isFile() && allowedPageFiles.has(entry.name)) files.push(path.join(dir, entry.name));
  }
  return files;
}

function routeFromPageFile(file) {
  const relative = path.relative(appDir, path.dirname(file)).split(path.sep).filter(Boolean);
  const visible = relative.filter((segment) => !/^\([^)]*\)$/.test(segment) && !/^@/.test(segment) && segment !== '_');
  const route = '/' + visible.filter((segment) => !/^\[\[\.\.\..+\]\]$/.test(segment)).map((segment) => {
    if (/^\[\.\.\..+\]$/.test(segment)) return '*' + segment.slice(5, -1);
    if (/^\[\[\.\.\..+\]\]$/.test(segment)) return '*' + segment.slice(8, -2);
    return segment;
  }).join('/');
  return route === '/' ? '/' : route.replace(/\/$/, '');
}

try {
  const stat = await fs.stat(appDir);
  if (!stat.isDirectory()) throw new Error(`App path is not a directory: ${appDir}`);
} catch (error) {
  console.error(`Cannot inventory Next.js app directory: ${appDir}`);
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
}

const pageFiles = await walk(appDir);
const pages = pageFiles.map((file) => ({
  route: routeFromPageFile(file),
  source_files: [path.relative(process.cwd(), file) || file],
  action: [],
  view_access: [],
})).sort((a, b) => a.route.localeCompare(b.route));

const inventory = {
  schema_version: '1.0.0',
  generated_at: new Date().toISOString(),
  app_directory: appDir,
  pages,
};
await fs.mkdir(path.dirname(output), { recursive: true });
await fs.writeFile(output, JSON.stringify(inventory, null, 2) + '\n');
console.log(`Wrote ${pages.length} routes to ${output}`);
