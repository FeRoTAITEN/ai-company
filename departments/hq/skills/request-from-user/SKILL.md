---
name: request-from-user
description: "File a request to the owner for a file, credential, decision, or physical action, then continue other work. Use whenever progress needs something only the owner can provide."
---

# Request from the owner

## Procedure
1. Find the next number: highest `REQ-<n>` in `C:\AI\REQUESTS.md` + 1.
2. Append:
   ```
   ## REQ-<n> | <project> | open
   Need: <exactly what, with exact file names / values / steps on the console>
   Why: <one line>
   Put it in: inbox/<project>/files/<filename>
   Answer in: inbox/<project>/answers.md under REQ-<n>
   ```
3. Ensure `inbox/<project>/files/` exists.
4. Mark the dependent PLAN.md step `blocked (REQ-<n>)` and continue with independent steps.
5. When answered: move files into the project, set the request to `closed`, commit.

## Rules
- One request per need; be exact so the owner never has to ask back.
- Never ask for a secret to be written into a file. Ask the owner to set an environment variable and give only its name.
