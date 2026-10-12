---
name: new-department
description: "Scaffold and register a new department plugin (agents, skills, knowledge) in the local ai-company marketplace. Use when the owner asks for a new capability area."
---

# New department

## Procedure
1. Create the plugin skeleton:
   ```
   departments/<dept>/
     .claude-plugin/plugin.json   {"name":"<dept>","version":"1.0.0","description":"<one line>"}
     agents/<dept>-director.md    director: plans, delegates to specialists, enforces QA
     agents/<specialist>.md       one file per role
     skills/<skill>/SKILL.md      one folder per repeatable procedure
     knowledge/README.md
     .mcp.json                    only if the department needs MCP servers
   ```
2. Agent files: YAML frontmatter `name` (unique across all departments), `description` (one line, quoted), `model: inherit`. Detailed instructions in the body.
3. Add an entry to `departments/.claude-plugin/marketplace.json` with `"source": "./<dept>"`. The entry `name` must equal the plugin.json `name`.
4. Validate and install:
   ```powershell
   claude plugin validate C:\AI\departments
   claude plugin marketplace update ai-company
   claude plugin install <dept>@ai-company
   ```
5. Add the skills folder to Hermes `skills.external_dirs` if Hermes is used.
6. Update "Active departments" in `C:\AI\AGENTS.md`, commit.

## Pitfalls
- Relative `source` paths must not contain `..`.
- Keep total agent descriptions short; very long description sets trigger a startup warning and worse routing.
