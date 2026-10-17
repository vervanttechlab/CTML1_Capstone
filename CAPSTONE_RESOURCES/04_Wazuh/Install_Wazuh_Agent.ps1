<#
  CTM Level 1 Capstone - Install + configure the Wazuh Windows agent (Day 3)
  Run INSIDE the Windows lab VM as Administrator:
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\Install_Wazuh_Agent.ps1 -WazuhIP 192.168.56.101 -Version 4.9.2

  IMPORTANT: -Version must be the SAME as (or older than) your Wazuh
  server version. Check it in the dashboard: menu (top-left) > About.
#>
param(
    [Parameter(Mandatory = $true)][string]$WazuhIP,
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$AgentName = $env:COMPUTERNAME,
    [string]$AgentGroup = "default"
)

$ErrorActionPreference = "Stop"
$ossecDir  = "C:\Program Files (x86)\ossec-agent"
$ossecConf = Join-Path $ossecDir "ossec.conf"

Write-Host "`n=== Installing Wazuh agent $Version -> manager $WazuhIP ===`n" -ForegroundColor Cyan

# 1. Connectivity test first (most common failure)
foreach ($port in 1514, 1515) {
    $t = Test-NetConnection -ComputerName $WazuhIP -Port $port -WarningAction SilentlyContinue
    if (-not $t.TcpTestSucceeded) {
        throw "Cannot reach $WazuhIP on TCP $port. Is the Wazuh VM running and on the host-only network?"
    }
    Write-Host "[+] Port $port reachable" -ForegroundColor Green
}

# 2. Download + silent install
if (-not (Get-Service -Name WazuhSvc -ErrorAction SilentlyContinue)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $msi = Join-Path $env:TEMP "wazuh-agent-$Version-1.msi"
    $url = "https://packages.wazuh.com/4.x/windows/wazuh-agent-$Version-1.msi"
    Write-Host "Downloading $url ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $msi -UseBasicParsing
    $msiArgs = "/i `"$msi`" /q WAZUH_MANAGER=`"$WazuhIP`" WAZUH_AGENT_NAME=`"$AgentName`" WAZUH_AGENT_GROUP=`"$AgentGroup`""
    Start-Process msiexec.exe -ArgumentList $msiArgs -Wait
    Write-Host "[+] Agent installed" -ForegroundColor Green
} else {
    Write-Host "[=] Agent already installed - only updating configuration" -ForegroundColor Yellow
}

# 3. Add extra log sources + File Integrity Monitoring (only once)
$conf = Get-Content $ossecConf -Raw
if ($conf -notmatch "CTM-CAPSTONE") {
    Copy-Item $ossecConf "$ossecConf.bak-before-capstone" -Force
    $additions = @"

<!-- CTM-CAPSTONE additions -->
<ossec_config>
  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>Microsoft-Windows-PowerShell/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <localfile>
    <location>Microsoft-Windows-Windows Defender/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
  <syscheck>
    <directories check_all="yes" realtime="yes" report_changes="yes">C:\CapstoneFinance</directories>
  </syscheck>
</ossec_config>
"@
    Add-Content -Path $ossecConf -Value $additions -Encoding ASCII
    Write-Host "[+] Added Sysmon, PowerShell, Defender channels + FIM on C:\CapstoneFinance" -ForegroundColor Green
} else {
    Write-Host "[=] Capstone additions already present" -ForegroundColor Yellow
}

# 4. Start / restart the agent
Restart-Service -Name WazuhSvc -Force
Start-Sleep -Seconds 10
Get-Service WazuhSvc | Format-Table Name, Status -AutoSize

Write-Host "Last lines of the agent log (look for 'Connected to the server'):" -ForegroundColor Cyan
Get-Content (Join-Path $ossecDir "ossec.log") -Tail 15

Write-Host "`nNow open the dashboard: https://$WazuhIP  > Agents. Your agent should be ACTIVE (green).`n" -ForegroundColor Cyan
