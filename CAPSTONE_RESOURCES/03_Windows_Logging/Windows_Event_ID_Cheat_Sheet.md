# Windows Event ID Cheat Sheet — CTM Level 1 Capstone

**Where:** Event Viewer (`eventvwr.msc`) → Windows Logs / Applications and Services Logs.
Use **"Filter Current Log…"** and type the IDs.

## Security log — authentication

| ID | Meaning | Why a SOC cares |
|---|---|---|
| 4624 | Successful logon | Who got in, how (Logon Type) |
| 4625 | Failed logon | Password guessing / brute force |
| 4634 | Logoff | |
| 4648 | Logon with explicit credentials | "runas", lateral movement |
| 4672 | Special privileges (admin) logon | Admin activity |
| 4776 | Credential validation (NTLM) | Password checks |

### Logon types (field "Logon Type" in 4624 / 4625)

| Type | Meaning | Type | Meaning |
|---|---|---|---|
| 2 | Interactive (keyboard/console) | 7 | Unlock |
| 3 | Network (SMB, shares) | 10 | RemoteInteractive (RDP) |
| 4 | Batch (scheduled task) | 11 | Cached credentials |
| 5 | Service | | |

### 4625 failure codes (Status / Sub Status)

| Code | Meaning |
|---|---|
| `0xC000006D` | bad username or password (generic) |
| `0xC000006A` | correct user, **wrong password** |
| `0xC0000064` | user does **not** exist |
| `0xC0000234` | account locked out |
| `0xC0000072` | account disabled |

## Security log — account management

| ID | Meaning |
|---|---|
| 4720 | User account created |
| 4722 | User account enabled |
| 4724 | Password reset attempt |
| 4726 | User account deleted |
| 4732 | Member added to a local security group (e.g. Administrators) |
| 4733 | Member removed from a local security group |
| 4740 | Account locked out |

## Security log — execution / persistence / tampering

| ID | Meaning |
|---|---|
| 4688 | New process created (shows Command Line after our script) |
| 4698 | Scheduled task created |
| 4719 | Audit policy changed |
| 1102 | **Security log cleared** — always suspicious! |

## System log

| ID | Meaning |
|---|---|
| 7045 | New service installed |
| 7036 | Service started / stopped |

## Sysmon
*Applications and Services Logs → Microsoft → Windows → Sysmon*

| ID | Meaning |
|---|---|
| 1 | Process create (with hashes, parent process, command line) |
| 3 | Network connection |
| 12 / 13 / 14 | Registry key/value created, set, renamed |
| 22 | DNS query |
| 26 | File delete detected |

## PowerShell (Microsoft-Windows-PowerShell/Operational)

| ID | Meaning |
|---|---|
| 4103 | Module logging (pipeline execution) |
| 4104 | Script block logging (the actual code that ran — even decoded!) |

## Microsoft Defender (Microsoft-Windows-Windows Defender/Operational)

| ID | Meaning |
|---|---|
| 1116 | Malware detected |
| 1117 | Action taken (quarantine / remove) |
| 5001 | Real-time protection **disabled** — suspicious |

## Quick PowerShell queries (run as Administrator)

```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 20
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4720,4732}
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; Id=1} -MaxEvents 30 |
    Select-Object TimeCreated, Message | Format-List
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; Id=4104} -MaxEvents 10
```
