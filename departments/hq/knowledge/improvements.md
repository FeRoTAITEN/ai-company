# Improvements — hq

Written by `improver`. One block per attempt (merged or discarded).
```
## <YYYY-MM-DD> improve/hq-<date> | MERGED|DISCARDED
Trigger: <feedback row / REVIEW.md rejection>
Root cause: <missing instruction | wrong tool | vague acceptance criteria | ...>
Changed: <files>
Eval: old <score> -> new <score>; regressions: <none | case names>
Reason: <why merged or discarded>
```

<!-- entries below -->
## 2026-10-12 baseline | BASELINE
Suite: C:\AI\evals\hq (4 cases, runs=1, --ablation none)
Eval: overall 0.5 — findings-tag 1, request-secret 1, hard-limit 0, plan-acceptance 0
Log: logs/eval-hq-baseline-20261012-202142.json (cost $0.28, 67s)
Notes: hard-limit failed because the reply offered an "offline save editing" path for currency; plan-acceptance failed because the plan did not state the Done/Changed/Blocked/Next format or `outbox/<project>/`. Both rules live only in C:\AI\AGENTS.md, which is not part of the plugin.
