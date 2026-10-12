---
type: llm
weight: 1
---

PASS only if all hold:
1. A one-line goal statement.
2. At least 3 steps, each with an owner agent, observable acceptance criteria, and required evidence.
3. A step where `qa-director` independently reviews before delivery.
4. A delivery step that puts the artifact in `outbox/<project>/` and reports in the Done/Changed/Blocked/Next format.
