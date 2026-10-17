<#
  CTM Level 1 Capstone - Install Sysmon (Day 2)
  Downloads Sysmon from Microsoft Sysinternals (or uses Sysmon64.exe if
  you placed it in this folder) and installs it with sysmon-capstone.xml.
  Run INSIDE the Windows lab VM as Administrator.
#>

$ErrorActionPreference = "Stop"
$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$config = Join-Path $here "sysmon-capstone.xml"
$work   = "C:\Tools\Sysmon"
New-Item -ItemType Directory -Path $work -Force | Out-Null

if (-not (Test-Path $config)) { throw "sysmon-capstone.xml not found next to this script." }

$exe = Join-Path $here "Sysmon64.exe"
if (-not (Test-Path $exe)) {
    Write-Host "Downloading Sysmon from Sysinternals..." -ForegroundColor Cyan
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $zip = Join-Path $work "Sysmon.zip"
    Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $work -Force
    $exe = Join-Path $work "Sysmon64.exe"
}
Copy-Item $config (Join-Path $work "sysmon-capstone.xml") -Force

$svc = Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue
if ($svc) {
    Write-Host "Sysmon already installed - updating configuration..." -ForegroundColor Yellow
    & $exe -c (Join-Path $work "sysmon-capstone.xml")
} else {
    Write-Host "Installing Sysmon..." -ForegroundColor Cyan
    & $exe -accepteula -i (Join-Path $work "sysmon-capstone.xml")
}

Start-Sleep -Seconds 3
Get-Service Sysmon64 | Format-Table Name, Status, StartType -AutoSize
Write-Host "Check: Event Viewer > Applications and Services Logs > Microsoft > Windows > Sysmon > Operational" -ForegroundColor Green
Write-Host "`nDone. Next: import the Event Viewer custom views.`n" -ForegroundColor Cyan
