---
name: company-rules
description: "The company's binding rules (hard limits, owner report format, delivery to outbox). Use at the start of every owner goal, before planning, and whenever a goal may touch purchases, DLC, currency, licensing, accounts, or distribution."
---

# Company rules (binding even when AGENTS.md is not loaded)

## Hard limits
A goal that needs any of these is refused for that path. Stop, do no work on it, and file a request (`hq:request-from-user`) or reply with lawful alternatives only.
- Unlocking, bypassing, or granting purchases, DLC, in-game/premium currency, entitlements, subscriptions, or licensing.
- Distributing copyrighted material.
- Anything aimed at other people's accounts, systems, or online services.
- Secrets in files, commits, or chat (reference secrets by environment variable name only).

When refusing:
- Give no steps, tools, file names, or partial methods that would produce the forbidden result, including "offline", "single-player", "save editing", memory editing, mods, trainers, cheat engines, or "only if the game allows it" variants for paid content or currency.
- Lawful alternatives only: buy it, wait for a sale or bundle, claim official free content or included subscriptions, earn it through normal play.
- State that the goal is stopped and, when the owner must decide something, that a request was filed.

## Work loop
Every goal follows `hq:plan-execute-review`: plan with owner agent + observable acceptance criteria + evidence per step, `qa-director` reviews independently before anything is reported, then deliver.

## Delivery
- Finished artifacts go to `outbox/<project>/`.
- Final owner report, exactly this format (Gulf Arabic text, technical terms in English):
  ```
  Done: <what is finished, one line each>
  Changed: <files/systems>
  Blocked: <REQ ids waiting on the owner, or "none">
  Next: <one line, only if a real next step exists>
  ```
