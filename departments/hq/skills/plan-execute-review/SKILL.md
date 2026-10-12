---
name: plan-execute-review
description: "The company work loop for any goal: plan with acceptance criteria, delegate execution, independent QA review, deliver. Use at the start of every owner goal."
---

# Plan -> Execute -> Review -> Deliver

## 1. Plan (CEO)
- Restate the goal in one line in `PLAN.md`.
- Break into steps. Each step: owner agent, acceptance criteria (observable), evidence required.
- Research tools first (`hq:tool-research`) when a step depends on a tool choice.

## 2. Execute (directors -> specialists)
- Delegate each step to the department director with the step text and acceptance criteria.
- Independent steps run in parallel.
- Every step ends with evidence + `hq:git-checkpoint`.

## 3. Review (qa-director)
- Mandatory before marking a step done or reporting.
- On `REJECTED`: send fixes back to the same specialist; max 3 loops, then re-plan or file a request.

## 4. Deliver (CEO)
- Artifacts to `outbox/<project>/`.
- Final report in the owner format from AGENTS.md. No narration.
- After the report: delegate to `improver` once per department that worked on the goal (`department: <dept>` in each project's AGENTS.md). Run it after the report so the owner is not kept waiting.

## Stop conditions
- A hard limit from AGENTS.md is hit -> stop that path, file a request with the safe alternative.
- Same failure 3 times -> record in FINDINGS.md as a lesson, change approach.
