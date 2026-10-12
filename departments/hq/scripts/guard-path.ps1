# PreToolUse guard for Write/Edit tools. Exit 2 = block (stderr goes to Claude). Exit 0 = allow.
$ErrorActionPreference = 'Stop'
try {
    $raw = [Console]::In.ReadToEnd()
    $j = $raw | ConvertFrom-Json
} catch { exit 0 }

$ti = $j.tool_input
$p = $null
foreach ($k in @('file_path', 'notebook_path', 'path')) {
    if ($ti -and $ti.PSObject.Properties[$k] -and $ti.$k) { $p = [string]$ti.$k; break }
}
if (-not $p) { exit 0 }

$sep = [IO.Path]::DirectorySeparatorChar
function Normalize([string]$x) {
    $x = [Environment]::ExpandEnvironmentVariables($x)
    $x = $x.Replace('/', $sep).Replace('\', $sep)
    return [IO.Path]::GetFullPath($x).TrimEnd($sep)
}

if (-not [IO.Path]::IsPathRooted($p)) {
    $base = $j.cwd
    if (-not $base) { $base = (Get-Location).Path }
    $p = Join-Path $base $p
}
$full = Normalize $p

$cfgPath = Join-Path $PSScriptRoot 'guard.json'
$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json

foreach ($seg in $cfg.protectedSegments) {
    $needle = $sep + $seg + $sep
    if (($full + $sep).IndexOf($needle, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        [Console]::Error.WriteLine("Blocked by workspace guard: '$full' is inside a protected '$seg' folder. Copy it to work/ and edit the copy.")
        exit 2
    }
}

foreach ($r in $cfg.allowedWriteRoots) {
    try { $root = Normalize $r } catch { continue }
    if (($full + $sep).StartsWith($root + $sep, [StringComparison]::OrdinalIgnoreCase)) { exit 0 }
}

[Console]::Error.WriteLine("Blocked by workspace guard: '$full' is outside the allowed write roots (departments/hq/scripts/guard.json). Work inside C:\AI or file a request in REQUESTS.md.")
exit 2
