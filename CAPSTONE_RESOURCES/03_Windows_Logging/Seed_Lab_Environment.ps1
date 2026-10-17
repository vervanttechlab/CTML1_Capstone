<#
  CTM Level 1 Capstone - Seed Lab Environment (Day 2)
  Creates the FICTIONAL company "BlueHarbor Finance" inside the lab VM:
    - 3 normal local users
    - C:\CapstoneFinance folder with sample (fake) business files
  Run INSIDE the Windows lab VM as Administrator.
#>

$ErrorActionPreference = "Stop"
Write-Host "`n=== Seeding BlueHarbor Finance lab environment ===`n" -ForegroundColor Cyan

# Lab-only passwords for fictional users. j.santos has a deliberately WEAK
# password - this is part of the Day 4 story (weak password = risk).
$users = @(
    @{ Name = "j.santos"; Full = "Jamie Santos";  Desc = "IT Helpdesk";      Pass = "Summer2026!";      Admin = $true  },
    @{ Name = "m.reyes";  Full = "Morgan Reyes";  Desc = "Finance Analyst";  Pass = "Lab-Mr7#qPz2v9";   Admin = $false },
    @{ Name = "a.cruz";   Full = "Alex Cruz";     Desc = "HR Officer";       Pass = "Lab-Ac4!wXe8n3";   Admin = $false }
)

foreach ($u in $users) {
    if (-not (Get-LocalUser -Name $u.Name -ErrorAction SilentlyContinue)) {
        $sec = ConvertTo-SecureString $u.Pass -AsPlainText -Force
        New-LocalUser -Name $u.Name -Password $sec -FullName $u.Full -Description $u.Desc -PasswordNeverExpires | Out-Null
        Add-LocalGroupMember -Group "Users" -Member $u.Name -ErrorAction SilentlyContinue
        if ($u.Admin) { Add-LocalGroupMember -Group "Administrators" -Member $u.Name -ErrorAction SilentlyContinue }
        Write-Host "[+] Created user $($u.Name) ($($u.Desc))" -ForegroundColor Green
    } else {
        Write-Host "[=] User $($u.Name) already exists" -ForegroundColor Yellow
    }
}

# Business folder that Wazuh File Integrity Monitoring will watch
$dir = "C:\CapstoneFinance"
New-Item -ItemType Directory -Path $dir -Force | Out-Null

@"
EmployeeID,Name,Department,MonthlySalary
E-1001,Jamie Santos,IT,42000
E-1002,Morgan Reyes,Finance,55000
E-1003,Alex Cruz,HR,48000
E-1004,Riley Tan,Finance,61000
"@ | Set-Content -Path "$dir\Q3_Payroll.csv" -Encoding UTF8

@"
Vendor,Bank,AccountNumber (FAKE)
Harbor Supplies,Example Bank,0000-1111-2222
Blue Logistics,Sample Bank,0000-3333-4444
"@ | Set-Content -Path "$dir\Vendor_Bank_Details.csv" -Encoding UTF8

@"
BlueHarbor Finance - Board Notes (FICTIONAL TRAINING DATA)
Q3 revenue target met. Audit scheduled next quarter.
"@ | Set-Content -Path "$dir\Board_Meeting_Notes.txt" -Encoding UTF8

Write-Host "[+] Created $dir with 3 sample files" -ForegroundColor Green
Write-Host "`nDone. Next: run Enable_Audit_Logging.ps1`n" -ForegroundColor Cyan
