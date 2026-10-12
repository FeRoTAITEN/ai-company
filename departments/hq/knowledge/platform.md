# Platform facts (this machine)

- Windows 11 Pro 10.0.26200; Git 2.55; Node 22.15; Claude Code 2.1.296.  [CONFIRMED 2026-10-12]
- Hermes config lives at `%LOCALAPPDATA%\hermes\config.yaml` (not `%USERPROFILE%\.hermes`). hq skills are wired via `skills.external_dirs`.  [CONFIRMED 2026-10-12, `hermes skills list`]
- `claude plugin eval` only reads cases below the plugin dir. Company suites live in `C:\AI\evals\<dept>\` and `departments/hq/scripts/run-evals.ps1` copies them into a temp snapshot of the plugin per run.  [CONFIRMED 2026-10-12]
