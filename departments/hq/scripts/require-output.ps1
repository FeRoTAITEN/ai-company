# SubagentStop guard: a subagent may stop only when its final message carries evidence.
# Evidence = a file path, commit hash, fenced output block, URL, or a "Blocked:" / "REQ-<n>" line.
# Exit 2 = keep the subagent working (stderr is the reason). After 3 blocks the stop is allowed
# and ESCALATE is written so the CEO reassigns the task.
$ErrorActionPreference = 'Stop'
$maxBlocks = 3
$logDir = 'C:\AI\logs'
# Built-in read-only helpers answer in prose by design; do not gate them.
$exempt = @('Explore', 'Plan', 'claude-code-guide', 'statusline-setup')

try {
    $j = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch { exit 0 }  # never trap a subagent because of a malformed payload

$agentType = [string]$j.agent_type
$agentId = [string]$j.agent_id
if (-not $agentId) { $agentId = 'unknown' }
if ($exempt -contains $agentType) { exit 0 }

$msg = [string]$j.last_assistant_message
$patterns = @(
    '(?m)^```',                                   # fenced command output / code block
    '[A-Za-z]:[\\/][^\s`"'']+',                   # absolute Windows path
    '(?<![\w/.-])[\w.-]+(/[\w.-]+)+\.[A-Za-z0-9]{1,6}\b', # relative path with extension
    '\b[0-9a-f]{7,40}\b',                         # commit hash
    'https?://\S+',                               # source link
    '(?m)^\s*Blocked:',                           # blocked line
    '\bREQ-\d+\b'                                 # filed request id
)
$hasEvidence = $false
foreach ($p in $patterns) { if ($msg -match $p) { $hasEvidence = $true; break } }

$safeId = ($agentId -replace '[^\w.-]', '_')
$counter = Join-Path $logDir "retry-$safeId.txt"

if ($hasEvidence) {
    if (Test-Path $counter) { Remove-Item -Force $counter }
    exit 0
}

New-Item -ItemType Directory -Force $logDir | Out-Null
$n = 0
if (Test-Path $counter) {
    $first = (Get-Content $counter -TotalCount 1)
    if ($first -match '^\d+$') { $n = [int]$first }
}
$n++

if ($n -gt $maxBlocks) {
    Set-Content -Path $counter -Value @('ESCALATE', "agent_type=$agentType", "agent_id=$agentId", "time=$(Get-Date -Format s)") -Encoding utf8
    Write-Output (@{ systemMessage = "ESCALATE: subagent '$agentType' ($agentId) returned no evidence after $maxBlocks retries. CEO must reassign the task. See $counter" } | ConvertTo-Json -Compress)
    exit 0
}

Set-Content -Path $counter -Value "$n" -Encoding utf8
[Console]::Error.WriteLine("Return evidence: changed files, commands run with output, or a filed REQ id. (no-output guard, attempt $n of $maxBlocks)")
exit 2
