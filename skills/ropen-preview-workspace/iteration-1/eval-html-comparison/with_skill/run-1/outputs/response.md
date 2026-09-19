# Response

I’ll make a self-contained comparison page with two clearly labeled examples:

- **Inline layout:** the Mermaid diagram appears in the same scrolling document as the Markdown explanation.
- **Separate-pane layout:** the Markdown document and the Mermaid diagram are presented as independent panes, matching a split-terminal workflow.

The page will use inline CSS and self-contained diagram markup, with no CDN scripts, remote fonts, trackers, forms, or browser-to-agent callbacks. I’ll use `ropen` to open it on your Mac; it owns the existing routing and does not require you to run a preview server, open a port, or manage LAN/Tailscale/firewall settings. Tell me your preferred layout in chat after viewing it.

This is a plan-only evaluation, so I have not created the page or opened anything.

# Exact planned actions

1. Check the installed preview boundary before the first real preview:

   ```text
   command -v ropen
   ropen --version
   ropen --help
   ```

   If `ropen` is missing or its help does not document opening a file, stop with a concise diagnostic. Do not start a fallback server or change networking.

2. Select a private, repository-external session directory. Prefer:

   ```text
   ${XDG_RUNTIME_DIR}/ropen-previews/<session>/
   ```

   when that variable is absolute, owned by the current user, and writable; otherwise use a `mktemp -d` directory under `/tmp` with a `ropen-preview.XXXXXX` template. Validate that the final directory is a strict descendant of the selected preview root, set it to mode `0700`, and use a session name containing only ASCII letters, digits, `_`, and `-`. Never create preview state in the repository or in `.superpowers`.

3. Write one stable file, `<session>/mermaid-layout-comparison.html`, with mode `0600`. The HTML will contain the comparison copy, inline styles, and static inline diagram markup so it remains self-contained and does not expose private source or credentials.

4. Resolve and verify that the target is an existing regular file inside the private session directory. Reject an unresolved or option-like path.

5. Open the validated absolute path with the documented command, passing it as one argument:

   ```text
   ropen -q <absolute-path-to>/mermaid-layout-comparison.html
   ```

   Do not print or ask the user to visit an internal live-mount URL. Do not perform any browser interaction beyond opening the artifact.

6. Report that the comparison page is open, that `ropen` handled browser routing and live reload, and that feedback should be given in chat. For revisions, rewrite the same file and invoke `ropen -q` on the same path so the existing tab refreshes.

7. When the preview session is finished, validate the exact session path again and remove only that session directory. Report whether it was removed or intentionally retained for another revision.
