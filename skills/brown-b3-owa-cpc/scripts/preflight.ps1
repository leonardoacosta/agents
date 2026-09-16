$ErrorActionPreference = 'Stop'
$expected = '346-CPC-QJXVZ'
if ($env:COMPUTERNAME -ne $expected) { throw 'Unexpected CPC host. Confirm approved host before continuing.' }
$paths = @((Join-Path $env:USERPROFILE 'dev\b3owa-sideload-test'), (Join-Path $env:USERPROFILE 'dev\b3-owa'))
$repos = @()
foreach ($path in $paths) {
    if (Test-Path (Join-Path $path '.git')) {
        $head = (& git -C $path rev-parse HEAD)
        if ($LASTEXITCODE -ne 0) { throw 'Cannot read candidate revision' }
        $status = @(& git -C $path status --porcelain)
        if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect candidate worktree' }
        $repos += [pscustomobject]@{ path=$path; head=$head; dirtyCount=$status.Count }
    }
}
$tools = @{}
foreach ($name in @('git','node','npm','dotnet')) { $tools[$name] = [bool](Get-Command $name -ErrorAction SilentlyContinue) }
$ports = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in @(7266,5135,3001,3002,3003) } | Select-Object LocalPort,OwningProcess -Unique)
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
$root = [System.Windows.Automation.AutomationElement]::RootElement
$windows = $root.FindAll([System.Windows.Automation.TreeScope]::Children,[System.Windows.Automation.Condition]::TrueCondition)
[pscustomobject]@{ host=$env:COMPUTERNAME; repos=$repos; tools=$tools; ports=$ports; desktopWindowCount=$windows.Count; note='Discovery only. Window count is not proof of usable signed-in Office.' } | ConvertTo-Json -Depth 6
