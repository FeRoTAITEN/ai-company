---
name: tool-research
description: "Find the newest maintained tool or method for a task before using one. Use before any tool choice, install, or when a tool fails."
---

# Tool research

## Procedure
1. Describe the task, not a tool name. Search "<task> <current year>", "<task> github", and the relevant GitHub Topics page (github.com/topics/<topic>).
2. Read official repos/releases first, then docs, then issues/forums.
3. For each candidate record: repo, latest release + date, last commit, Windows support, install method, license, known issues.
4. Prefer: maintained in the last 6 months, Windows native, scriptable/headless, MCP-capable for agent use.
5. Save the result to `departments/<dept>/knowledge/tools-<task>.md` with source links.
6. If installing, update `departments/<dept>/tools/manifest.json` (name, version, path, source URL, sha256).
