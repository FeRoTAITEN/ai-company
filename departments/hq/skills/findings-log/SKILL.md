---
name: findings-log
description: "Record facts, addresses, hashes, and lessons in FINDINGS.md tagged CONFIRMED or ASSUMED, and promote reusable lessons to department knowledge. Use whenever something is learned."
---

# Findings log

## Entry format (append to `projects/<NAME>/FINDINGS.md`)
```
### <YYYY-MM-DD> <short title>  [CONFIRMED|ASSUMED]
What: <fact>
Evidence: <tool + output / file + hash / address>
Impact: <what it changes in the plan>
```

## Rules
- CONFIRMED only with tool output or a reproducible check. Everything else is ASSUMED.
- When an ASSUMED item is verified or disproved, update the same entry; never delete history.
- Reusable across projects (tool behavior, file formats, platform rules) -> also add to `departments/<dept>/knowledge/<topic>.md`.
- Lessons from failures -> `departments/<dept>/knowledge/lessons.md`.
