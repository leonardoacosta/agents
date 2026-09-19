Sure, here's a script that walks your app directory:

```typescript
// scripts/build-pages.ts
import fs from 'fs';
import path from 'path';

interface PageEntry {
  route: string;
  file: string;
}

function walk(dir: string, baseDir: string, pages: PageEntry[] = []): PageEntry[] {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(full, baseDir, pages);
    } else if (entry.name === 'page.tsx' || entry.name === 'page.ts') {
      const relativePath = path.relative(baseDir, full);
      const route = '/' + relativePath
        .replace(/\/page\.(tsx|ts)$/, '')
        .replace(/\([^)]+\)\//g, '')
        .replace(/\[([^\]]+)\]/g, ':$1')
        .replace(/\/+/g, '/')
        .replace(/\/$/, '');
      pages.push({ route, file: relativePath });
    }
  }
  return pages;
}

const baseDir = path.join(process.cwd(), 'apps/nextjs/src/app');
const pages = walk(baseDir, baseDir);
fs.writeFileSync('pages.json', JSON.stringify(pages, null, 2));
console.log(`Found ${pages.length} pages`);
```

Run it with `npx tsx scripts/build-pages.ts`. It outputs `pages.json` with route and file for each page. You can add permissions and actions manually in a spreadsheet or separate JSON file.