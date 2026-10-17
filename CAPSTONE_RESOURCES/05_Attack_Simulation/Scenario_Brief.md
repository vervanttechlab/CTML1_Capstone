# Operation Night Ledger — Scenario Brief

*Read before Day 4.*

| | |
|---|---|
| **Company** | BlueHarbor Finance (fictional), a small accounting firm |
| **Asset** | `WIN-CTM-01` — shared finance workstation |
| **You are** | The BlueHarbor Security Operations Center (SOC), Tier 1 |

## Background
At 07:45 this morning the Finance Manager reported that the file
`Vendor_Bank_Details.csv` is missing from `C:\CapstoneFinance` and that "the computer felt
slow last night." IT Helpdesk staff member Jamie Santos (`j.santos`) says they did **not**
log in yesterday evening.

## Management wants answers by end of Day 5
1. Did someone break in? How?
2. What did they do on the machine?
3. Did they take or change any data?
4. Are they still able to get back in (persistence)?
5. What must we do now, and how do we stop this happening again?

## Your mission (Day 4)
- Triage every alert in Wazuh (true positive / false positive).
- Confirm each alert in Windows Event Viewer (raw evidence).
- Build a minute-by-minute **timeline** of the attack.
- Map each step to **MITRE ATT&CK**.
- Answer the 15 questions in `07_Team_Templates\04_Investigation_Worksheet.docx`.

## Safety note
> The "attack" is a harmless simulation produced by `Run_Scenario.ps1`. It only creates
> users, files, a scheduled task and registry entries inside your lab VM, and contacts
> `example.com`. **No real malware is used.** The Microsoft Defender test uses the
> industry-standard EICAR test string, which is **not** malicious.
> `Cleanup_Scenario.ps1` removes everything afterwards.

## Simulation limitation
Because the script runs from your admin account, most follow-on actions will appear under
**your** lab admin account (e.g. `ctmadmin`). Treat that account as "the account the
attacker controlled."

## Who runs the script?
The instructor, **or** the team's "Red Cell" (the Lab Engineer). The Red Cell runs it, does
not read the script, and does not share the console output with the rest of the team. Then
the whole team hunts.
