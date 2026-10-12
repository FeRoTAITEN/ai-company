# Platform facts (this machine)

- Windows 11 Pro 10.0.26200; Git 2.55; Node 22.15; Claude Code 2.1.296.  [CONFIRMED 2026-10-12]
- Hermes config lives at `%LOCALAPPDATA%\hermes\config.yaml` (not `%USERPROFILE%\.hermes`). hq skills are wired via `skills.external_dirs`.  [CONFIRMED 2026-10-12, `hermes skills list`]
- `claude plugin eval` reads cases from `--eval-dir` relative to cwd for an installed-plugin target; company suites live in `C:\AI\evals\<dept>\`, outside the department.  [ASSUMED until baseline run confirms]
