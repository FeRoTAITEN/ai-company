---
name: new-project
description: "Create a new project under C:\\AI\\projects from the template, with its own git repo. Use when the owner names a goal for a project that does not exist yet."
---

# New project

## Procedure
1. Pick a short folder name (PascalCase or UPPER, no spaces), e.g. `Vault`, `Research1`.
2. Copy the template:
   ```powershell
   Copy-Item -Recurse C:\AI\templates\project C:\AI\projects\<NAME>
   ```
3. Fill `AGENTS.md` (first line `department: <dept>`), the goal in `PLAN.md`, and scope/limits.
4. Create `original\`, `work\`, `out\` folders. Put source material the owner provided into `original\` (read-only from then on).
5. Init git and commit:
   ```powershell
   cd C:\AI\projects\<NAME>; git init; git add -A; git commit -m "init project <NAME>"
   ```
6. Create `inbox\<NAME>\files\` and `outbox\<NAME>\`.

## Verification
`git -C C:\AI\projects\<NAME> log --oneline` shows the init commit; all template files exist.
