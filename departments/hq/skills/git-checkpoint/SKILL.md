---
name: git-checkpoint
description: "Commit work with a clear message after every meaningful step, in the correct repo (company repo C:\\AI or the project repo). Use after any change that should be kept."
---

# Git checkpoint

## Procedure
1. Decide the repo: company files (agents, skills, rules) -> `C:\AI`; project files -> `C:\AI\projects\<NAME>`.
2. Check for secrets before staging:
   ```powershell
   git -C <repo> diff | Select-String -Pattern 'sk-|api[_-]?key|token|password|secret' -CaseSensitive:$false
   ```
   Any hit: stop, remove the secret, use an env var name.
3. Commit:
   ```powershell
   git -C <repo> add -A
   git -C <repo> commit -m "<area>: <what changed> (<why>)"
   ```
4. If a remote exists, push: `git -C <repo> push`.

## Rules
- Never commit binaries or game data (see .gitignore). Record their hashes in FINDINGS.md instead.
- One logical change per commit.
