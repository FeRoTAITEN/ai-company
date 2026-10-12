# Lessons — hq

### 2026-10-12 Bash tool collapses `\` in heredocs/strings  [CONFIRMED]
What: JSON written from the Bash tool with `\` ended up with single backslashes, making guard.json invalid.
Evidence: guard-path.ps1 ConvertFrom-Json "Unrecognized escape sequence" on guard.json.
Impact: Write JSON with the Write tool, or use forward slashes in Windows paths inside JSON.

### 2026-10-12 Hooks fail open on exit 1  [CONFIRMED]
What: A PowerShell hook that throws exits 1, which Claude Code treats as non-blocking, so the write proceeds.
Evidence: guard-path.ps1 with broken guard.json returned exit=1 for an outside path.
Impact: Guard scripts must `trap` errors and exit 2 (fail closed).

### 2026-10-12 Plugin hooks do not load in the session that installed the plugin  [CONFIRMED]
What: After `claude plugin install hq@ai-company` mid-session, a Write to C:\Users\Public was not blocked.
Evidence: Write tool created C:\Users\Public\guard-test.txt (deleted afterwards).
Impact: After installing/editing plugins, run `/reload-plugins` or start a new session before relying on hooks.

### 2026-10-12 run-evals.ps1 from Git Bash picked GNU tar  [CONFIRMED]
What: Launched from Git Bash, `tar` resolved to /usr/bin/tar, failed on "C:" paths, and the eval ran against an empty plugin.
Evidence: logs/eval-hq-old-20261012-202953.json and eval-hq-new-20261012-203019.json (invalid runs, per improver report).
Impact: run-evals.ps1 now calls %SystemRoot%\System32\tar.exe and throws on failure.
