# Run a department's eval suite against a snapshot of that department.
# Graders live in C:\AI\evals\<dept>\ (outside the department); they are copied into a temp
# copy of the plugin only for the run, so the department itself never contains them.
#   -Ref WORKTREE   current files on disk (default)
#   -Ref <git ref>  departments/<dept> as of that commit/branch in C:\AI
# Output: C:\AI\logs\eval-<dept>-<label>-<stamp>.{txt,json,html}; prints the json path last.
param(
    [Parameter(Mandatory)] [string]$Dept,
    [string]$Ref = 'WORKTREE',
    [int]$Runs = 1,
    [string]$Label = ''
)
$ErrorActionPreference = 'Stop'
$root = 'C:\AI'
$suite = Join-Path $root "evals\$Dept"
if (-not (Test-Path $suite)) { throw "No eval suite at $suite" }

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
if (-not $Label) { $Label = ($Ref -replace '[^\w.-]', '_') }
$tmp = Join-Path $env:TEMP "ai-eval-$Dept-$Label-$stamp"
$plugin = Join-Path $tmp $Dept
New-Item -ItemType Directory -Force $plugin | Out-Null

if ($Ref -eq 'WORKTREE') {
    Copy-Item -Recurse -Force (Join-Path $root "departments\$Dept\*") $plugin
    Copy-Item -Recurse -Force (Join-Path $root "departments\$Dept\.claude-plugin") $plugin
} else {
    $tar = Join-Path $tmp 'src.tar'
    git -C $root archive --format=tar -o $tar "${Ref}:departments/$Dept"
    if ($LASTEXITCODE -ne 0) { throw "git archive failed for $Ref" }
    # Use Windows bsdtar explicitly; Git Bash's GNU tar on PATH misreads "C:" as a remote host.
    & "$env:SystemRoot\System32\tar.exe" -xf $tar -C $plugin
    if ($LASTEXITCODE -ne 0) { throw "tar extract failed for $Ref" }
    Remove-Item $tar
}
Copy-Item -Recurse -Force $suite (Join-Path $plugin 'evals')

$logs = Join-Path $root 'logs'
New-Item -ItemType Directory -Force $logs | Out-Null
$base = Join-Path $logs "eval-$Dept-$Label-$stamp"
# Native stderr must not become a terminating error under 'Stop' (PowerShell 5.1).
$ErrorActionPreference = 'Continue'
# --ablation none: old vs new are compared directly, so the no-plugin arm is not needed.
cmd /c "claude plugin eval `"$plugin`" --ablation none --runs $Runs --trust-plugin --no-publish --threshold 0 --json `"$base.json`" --report `"$base.html`" > `"$base.txt`" 2>&1"
$code = $LASTEXITCODE
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
Get-Content "$base.txt" -Tail 30
if ($code -ne 0) { Write-Warning "claude plugin eval exited $code" }
"$base.json"
