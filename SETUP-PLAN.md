# SETUP PLAN — AI Company (C:\AI)

Executor: CEO (Claude Code main session) unless marked **OWNER**.
Rule: every phase ends with its Verify block passing + `hq:git-checkpoint`. Mark each step `[x]` here.

---

## Phase 0 — Prerequisites (**OWNER**, once)

| Item | Check | Install if missing |
|---|---|---|
| Windows 10/11 | `winver` | — |
| Claude Code (logged in with Pro) | `claude --version` then `/status` | https://code.claude.com/docs/en/setup |
| Git | `git --version` | `winget install -e --id Git.Git` |
| Node.js 22+ | `node -v` | `winget install -e --id OpenJS.NodeJS.LTS` |
| GitHub CLI (optional) | `gh --version` | `winget install -e --id GitHub.cli` then `gh auth login` |
| Hermes (optional) | `hermes status` | https://hermes-agent.nousresearch.com/docs/getting-started/quickstart |

---

## Phase 1 — Install (**OWNER**, one block in PowerShell)

```powershell
Expand-Archive -Path "$env:USERPROFILE\Downloads\ai-company.zip" -DestinationPath C:\ -Force
cd C:\AI
git init; git add -A; git commit -m "init ai-company"
claude plugin marketplace add C:\AI\departments
claude plugin install hq@ai-company
claude
```
Then type: `ابدأ`

---

## Phase 2 — Verify load (CEO)

- [ ] `claude plugin list` shows `hq@ai-company` enabled.
- [ ] `claude plugin details hq` lists 5 agents (coo, qa-director, security-officer, researcher, department-builder) and 9 skills.
- [ ] `claude plugin validate C:\AI\departments` passes.

Verify: paste the three outputs into `logs/setup-phase2.txt`.

---

## Phase 3 — Guard hook test (CEO)

Use the Write tool (not the terminal) for each:

| Test | Path | Expected |
|---|---|---|
| inside workspace | `C:\AI\logs\guard-ok.txt` | written |
| outside workspace | `C:\Users\Public\guard-test.txt` | blocked, message "outside the allowed write roots" |
| protected folder | `C:\AI\projects\_guardtest\original\x.txt` | blocked, message "protected 'original' folder" |

- [ ] All three behave as expected. Delete `C:\AI\logs\guard-ok.txt` afterwards.
- [ ] If the hook does not fire: check `powershell.exe` is on PATH and run
      `powershell -NoProfile -ExecutionPolicy Bypass -File <plugin root>\scripts\guard-path.ps1` manually with a JSON sample.

---

## Phase 4 — Git & GitHub (CEO)

- [ ] `git -C C:\AI status` is clean.
- [ ] If `gh auth status` succeeds:
  ```powershell
  gh repo create ferotaiten/ai-company --private --source C:\AI --push
  ```
  Otherwise file a request (`hq:request-from-user`) asking the owner to run `gh auth login`.

Verify: `git -C C:\AI remote -v` shows the repo; `git -C C:\AI log origin/HEAD -1` matches local HEAD.

---

## Phase 5 — Hermes integration (CEO, only if `hermes` exists)

- [ ] Back up `%USERPROFILE%\.hermes\config.yaml` (`hq:backup-before-change`).
- [ ] Add without removing existing keys:
  ```yaml
  skills:
    external_dirs:
      - C:/AI/departments/hq/skills
  ```
- [ ] Never read or write `%USERPROFILE%\.hermes\.env`.

Verify: `hermes status` runs without error; in a Hermes session the hq skills appear in the skills list.

---

## Phase 6 — Self-improvement loop (CEO builds it inside the `hq` plugin)

### 6.1 Feedback capture
- [ ] Create `departments/<dept>/knowledge/feedback.md` template (date | goal | owner score 1–5 | owner note | QA verdict).
- [ ] Add rule to AGENTS.md: when the owner says the result is bad (any wording) or gives a score, append it to the department's `feedback.md` before doing anything else.
- [ ] `qa-director`: on every `REJECTED`, append the rejection to the same file.

### 6.2 No-output guard (SubagentStop hook)
- [ ] Add `departments/hq/scripts/require-output.ps1` + a `SubagentStop` entry in `departments/hq/hooks/hooks.json`.
- [ ] Logic: read stdin JSON; take `last_assistant_message`; if it contains no evidence (no file path, commit hash, command output block, or `Blocked:`/`REQ-` line) -> block with reason "Return evidence: changed files, commands run with output, or a filed REQ id".
- [ ] Loop guard: counter file `logs/retry-<agent_id>.txt`; after 3 blocks allow the stop and write `ESCALATE` so the CEO reassigns the task.
- [ ] Test with a dummy subagent that returns plain text: blocked 3 times, then escalates.

### 6.3 Improver agent
- [ ] Add `departments/hq/agents/improver.md` (one-line description: "Use after each completed goal or any owner complaint to improve a department's agents and skills from feedback, QA rejections, and logs.").
- [ ] Procedure in its body:
  1. Read `feedback.md`, recent `REVIEW.md` rejections, `logs/`.
  2. Find the root cause per failure (missing instruction, wrong tool, vague acceptance criteria).
  3. Edit only the affected agent/skill files of that department, on a git branch `improve/<dept>-<date>`.
  4. Run evals (6.4) on old vs new. Merge only if the new score is higher and no case regresses; otherwise discard the branch.
  5. Log the change and the scores in `departments/<dept>/knowledge/improvements.md`.
- [ ] The improved department is never told it is being evaluated; graders live outside it (`evals/` in hq).

### 6.4 Evals
- [ ] For each department: `claude plugin eval init` against `C:\AI\departments\<dept>`; store suites under `C:\AI\evals\<dept>\`.
- [ ] Every owner complaint or QA rejection becomes a new eval case (prompt + grader).
- [ ] Baseline run recorded in `departments/<dept>/knowledge/improvements.md`.

### 6.5 Trigger
- [ ] Add to the `hq:plan-execute-review` skill, step 4 (Deliver): after the final report, delegate to `improver` for each department that worked on the goal.

Verify phase 6: give one deliberately bad rating on a demo goal (Phase 7) -> feedback logged -> improver branch created -> eval comparison logged -> merged or discarded with reason.

---

## Phase 7 — End-to-end smoke test (CEO)

Goal to run: "Create project Demo and produce a one-page status report of the company setup."

- [ ] `projects/Demo` created from template, own git repo with init commit.
- [ ] `PLAN.md` has steps with owners and acceptance criteria.
- [ ] `qa-director` verdict written to `projects/Demo/REVIEW.md`.
- [ ] Report delivered to `outbox/Demo/`.
- [ ] Final message to the owner follows the report format in AGENTS.md.

---

## Phase 8 — Close (CEO)

- [ ] Mark all ONBOARDING.md items `[x]`.
- [ ] Commit and push.
- [ ] Send the owner the final report (Done / Changed / Blocked / Next).

---

## Known risks

| Risk | Mitigation |
|---|---|
| Guard hook covers file tools only, not terminal commands | Run agents under a separate Windows user with rights only on C:\AI for full isolation |
| SubagentStop block loops | Retry counter (max 3) + escalation |
| Improver degrades a department | Branch + eval gate + `git revert` |
| Too many agent descriptions | Keep each description one line; startup warning appears past ~15k tokens of descriptions |
| Plugin edits not picked up | Run `/reload-plugins` or restart the session |
