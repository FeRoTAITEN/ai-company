---
name: status-report
description: "Produce the owner-facing status of all projects and open requests. Use when the owner asks for status or at the end of a goal."
---

# Status report

## Procedure
1. For each `projects/*/PLAN.md`: count steps by status, take the current step.
2. List open items in `C:\AI\REQUESTS.md`.
3. Last commit per repo: `git -C <repo> log -1 --format="%h %s %cr"`.

## Output (Gulf Arabic, terse)
```
<project>: <done>/<total> | now: <step> | blocked: <REQ ids or none>
Requests: <REQ-n: one line each>
```
