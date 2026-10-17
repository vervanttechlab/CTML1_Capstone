<#
  CTM Level 1 Capstone - Preflight Check
  Run INSIDE the Windows lab VM, PowerShell as Administrator:
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\Preflight_Check.ps1 -WazuhIP 192.168.56.101
  It only READS settings. It changes nothing.
#>
param(
    [string]$WazuhIP = ""
)

$results = @()
function Add-Result($Check, $Ok, $Hint) {
    $script:results += [pscustomobject]@{
        Check  = $Check
        Status = $(if ($Ok) { "PASS" } else { "FAIL" })
        Hint   = $(if ($Ok) { "" } else { $Hint })
    }
}

Write-Host "`n=== CTM Capstone Preflight Check ===`n" -ForegroundColor Cyan

# 1. Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Add-Result "Running as Administrator" $isAdmin "Right-click PowerShell > Run as administrator"

# 2. Hostname
Add-Result "Hostname is WIN-CTM-01" ($env:COMPUTERNAME -eq "WIN-CTM-01") "Optional but recommended: Rename-Computer -NewName WIN-CTM-01 -Restart"

# 3. Host-only IP
$hostOnly = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -like "192.168.56.*" }
Add-Result "Host-only IP (192.168.56.x) present" ([bool]$hostOnly) "Add Adapter 2 = Host-only Adapter in VirtualBox settings"

# 4. Audit policy - Logon failure
$logon = (auditpol /get /subcategory:"Logon") -join " "
Add-Result "Audit Logon success+failure" ($logon -match "Success and Failure") "Run 03_Windows_Logging\Enable_Audit_Logging.ps1"

# 5. Process creation auditing
$proc = (auditpol /get /subcategory:"Process Creation") -join " "
Add-Result "Audit Process Creation" ($proc -match "Success") "Run 03_Windows_Logging\Enable_Audit_Logging.ps1"

# 6. PowerShell script block logging
$sbl = Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -ErrorAction SilentlyContinue
Add-Result "PowerShell Script Block Logging" ($sbl.EnableScriptBlockLogging -eq 1) "Run 03_Windows_Logging\Enable_Audit_Logging.ps1"

# 7. Sysmon
$sysmon = Get-Service -Name Sysmon64, Sysmon -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Running" }
Add-Result "Sysmon service running" ([bool]$sysmon) "Run 03_Windows_Logging\Install_Sysmon.ps1"

# 8. Seed data
Add-Result "C:\CapstoneFinance folder exists" (Test-Path "C:\CapstoneFinance") "Run 03_Windows_Logging\Seed_Lab_Environment.ps1"
$js = Get-LocalUser -Name "j.santos" -ErrorAction SilentlyContinue
Add-Result "Seed user j.santos exists" ([bool]$js) "Run 03_Windows_Logging\Seed_Lab_Environment.ps1"

# 9. Wazuh agent
$agent = Get-Service -Name WazuhSvc -ErrorAction SilentlyContinue
Add-Result "Wazuh agent installed" ([bool]$agent) "Run 04_Wazuh\Install_Wazuh_Agent.ps1 (Day 3)"
if ($agent) {
    Add-Result "Wazuh agent running" ($agent.Status -eq "Running") "Start-Service WazuhSvc ; check ossec.log"
}

# 10. Connectivity to Wazuh
if ($WazuhIP) {
    foreach ($port in 1514, 1515, 443) {
        $t = Test-NetConnection -ComputerName $WazuhIP -Port $port -WarningAction SilentlyContinue
        Add-Result "Reach Wazuh $WazuhIP port $port" $t.TcpTestSucceeded "Is the Wazuh VM on? Same host-only network? Correct IP?"
    }
} else {
    Write-Host "Tip: add -WazuhIP <ip> to also test network ports.`n" -ForegroundColor Yellow
}

# 11. Security log size
$secLog = Get-WinEvent -ListLog Security
Add-Result "Security log >= 100 MB" ($secLog.MaximumSizeInBytes -ge 100MB) "Run 03_Windows_Logging\Enable_Audit_Logging.ps1"

foreach ($r in $results) {
    $color = if ($r.Status -eq "PASS") { "Green" } else { "Red" }
    Write-Host ("[{0}] {1}" -f $r.Status, $r.Check) -ForegroundColor $color
    if ($r.Hint) { Write-Host ("       -> {0}" -f $r.Hint) -ForegroundColor DarkYellow }
}
$pass = ($results | Where-Object Status -eq "PASS").Count
Write-Host ("`nScore: {0} / {1} checks passed" -f $pass, $results.Count) -ForegroundColor Cyan
Write-Host "Take a screenshot of this window for your checkpoint evidence.`n"
