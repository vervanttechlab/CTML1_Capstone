<#
  CTM Level 1 Capstone - Cleanup after "Operation Night Ledger"
  Removes everything Run_Scenario.ps1 created and restores the finance
  files. Run INSIDE the lab VM as Administrator, AFTER your team has
  collected all evidence (Day 5 or end of Day 4).

      .\Cleanup_Scenario.ps1               # undo the scenario only
      .\Cleanup_Scenario.ps1 -RemoveSeed   # also remove seed users + folder
#>
param([switch]$RemoveSeed)

$ErrorActionPreference = "SilentlyContinue"
Write-Host "`n=== Cleaning up Operation Night Ledger ===`n" -ForegroundColor Cyan

Remove-LocalUser -Name "svc_update";                                   Write-Host "[-] Removed user svc_update"
Unregister-ScheduledTask -TaskName "OneDriveSyncHelper" -Confirm:$false; Write-Host "[-] Removed task OneDriveSyncHelper"
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "UpdaterSvc"; Write-Host "[-] Removed Run key UpdaterSvc"
Remove-Item "C:\ProgramData\SyncHelper" -Recurse -Force;               Write-Host "[-] Removed C:\ProgramData\SyncHelper"
Remove-Item "C:\Users\Public\ctm_beacon.txt" -Force;                   Write-Host "[-] Removed ctm_beacon.txt"
Remove-Item "C:\Users\Public\Downloads\invoice_tool.exe.txt" -Force

# Restore finance data
$payroll = "C:\CapstoneFinance\Q3_Payroll.csv"
if (Test-Path $payroll) {
    (Get-Content $payroll) | Where-Object { $_ -notmatch "svc_update" } | Set-Content $payroll -Encoding UTF8
    Write-Host "[+] Restored Q3_Payroll.csv"
}
if ((Test-Path "C:\CapstoneFinance") -and -not (Test-Path "C:\CapstoneFinance\Vendor_Bank_Details.csv")) {
@"
Vendor,Bank,AccountNumber (FAKE)
Harbor Supplies,Example Bank,0000-1111-2222
Blue Logistics,Sample Bank,0000-3333-4444
"@ | Set-Content -Path "C:\CapstoneFinance\Vendor_Bank_Details.csv" -Encoding UTF8
    Write-Host "[+] Restored Vendor_Bank_Details.csv"
}

if ($RemoveSeed) {
    foreach ($u in "j.santos", "m.reyes", "a.cruz") { Remove-LocalUser -Name $u }
    Remove-Item "C:\CapstoneFinance" -Recurse -Force
    Write-Host "[-] Removed seed users and C:\CapstoneFinance"
}

Write-Host "`nCleanup complete. You can re-run Seed + Run_Scenario to practise again.`n" -ForegroundColor Cyan
