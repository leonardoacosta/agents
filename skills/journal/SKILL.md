---
name: journal
description: Validate and append project journal entries without re-deriving the journal format.
---

# Journal

## Conventions

- Use straight ASCII only. Do not use em dashes, en dashes, or curly quotes.
- Use a top-level H2 project heading and H3 dated sections for entries.
- Open every entry with a `### Summary` section.
- Do not use emoji, chatbot phrasing, or binary contrasts.
- Language-tag every fenced code block and keep fences balanced.
- Anchor URLs in links. Do not leave bare URLs.
- Do not use double blank lines.
- Run the banned-vocabulary word-boundary scan and require zero hits.

These conventions are mirrored in project memory `mem_1789820913458`.

## Procedure

1. Draft the new entry using the conventions above.
2. Validate the complete new entry, including ASCII, headings, Summary placement, code fences,
   links, blank-line spacing, and the banned-vocabulary word-boundary scan.
3. Peek at the journal tail only as needed to identify the correct existing project heading.
4. Append under that heading. Create a top-level project heading only for a genuinely new project.
5. Never rewrite or reformat existing entries.

The conventions live here and in project memory. Never re-read the whole journal to re-derive them.
