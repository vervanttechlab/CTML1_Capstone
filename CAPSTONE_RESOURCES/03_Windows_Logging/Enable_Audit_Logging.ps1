<#
  CTM Level 1 Capstone - Enable Windows Audit Logging (Day 2)
  Turns on the audit categories a SOC analyst needs, enables PowerShell
  logging, adds command lines to Event 4688, and enlarges the logs.
  Run INSIDE the Windows lab VM as Administrator (English Windows).
#>

Write-Host "`n=== Enabling Windows audit logging ===`n" -ForegroundColor Cyan

# Subcategory -> what you will see in Event Viewer
$subcats = [ordered]@{
    "Credential Validation"      = "4776 credential checks"
    "Logon"                      = "4624 success / 4625 failure"
    "Logoff"                     = "4634 / 4647"
    "Special Logon"              = "4672 admin logon"
    "User Account Management"    = "4720 created / 4722 enabled / 4724 pw reset / 4726 deleted"
    "Security Group Management"  = "4732 added to local group"
    "Process Creation"           = "4688 new process"
    "Other Object Access Events" = "4698 scheduled task created"
    "Audit Policy Change"        = "4719 audit policy changed"
}

foreach ($s in $subcats.Keys) {
    auditpol /set /subcategory:"$s" /success:enable /failure:enable | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host ("[+] {0,-28} -> {1}" -f $s, $subcats[$s]) -ForegroundColor Green
    } else {
        Write-Host ("[!] Could not set '{0}' (non-English Windows?)" -f $s) -ForegroundColor Red
    }
}

# Include the full command line in Event 4688
$p = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
New-Item -Path $p -Force | Out-Null
Set-ItemProperty -Path $p -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1 -Type DWord
Write-Host "[+] Command line added to Event 4688" -ForegroundColor Green

# PowerShell Script Block Logging (Event 4104) + Module Logging (4103)
$sb = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
New-Item -Path $sb -Force | Out-Null
Set-ItemProperty -Path $sb -Name "EnableScriptBlockLogging" -Value 1 -Type DWord
$ml = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
New-Item -Path $ml -Force | Out-Null
Set-ItemProperty -Path $ml -Name "EnableModuleLogging" -Value 1 -Type DWord
New-Item -Path "$ml\ModuleNames" -Force | Out-Null
Set-ItemProperty -Path "$ml\ModuleNames" -Name "*" -Value "*"
Write-Host "[+] PowerShell Script Block + Module logging enabled" -ForegroundColor Green

# Bigger logs so evidence is not overwritten during the week
wevtutil sl Security /ms:209715200
wevtutil sl "Microsoft-Windows-PowerShell/Operational" /ms:104857600
Write-Host "[+] Security log = 200 MB, PowerShell log = 100 MB" -ForegroundColor Green

Write-Host "`nCurrent audit policy (screenshot this for your checkpoint):`n" -ForegroundColor Cyan
auditpol /get /category:"Logon/Logoff","Account Management","Detailed Tracking"

Write-Host "`nDone. Next: run Install_Sysmon.ps1`n" -ForegroundColor Cyan
