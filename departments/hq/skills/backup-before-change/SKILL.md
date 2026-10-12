---
name: backup-before-change
description: "Back up any non-reproducible file or config before modifying it, with a hash record. Use before editing binaries, user configs, or anything outside a project's work folder."
---

# Backup before change

## Procedure
```powershell
$src = "<path>"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dst = "C:\AI\backups\$stamp\" + (Split-Path $src -Leaf)
New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
Copy-Item -Recurse -Force $src $dst
Get-FileHash $src -Algorithm SHA256 | Select-Object Hash, Path
```
Record the backup path and hash in the project's FINDINGS.md.

## Rules
- `original/` folders are never modified, so they need no backup; copy them to `work/` instead.
- Restore = copy the backup back and verify the hash.
