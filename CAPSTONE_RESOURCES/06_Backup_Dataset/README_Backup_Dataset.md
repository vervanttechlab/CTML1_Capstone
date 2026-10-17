# Backup Dataset — Plan B

Use these files **only** if your live lab fails on Day 4 (for example the Wazuh agent never
connected, or a VM broke). They contain the **same** incident "Operation Night Ledger" that
`Run_Scenario.ps1` produces, exported as flat files, so your team can still finish the
investigation.

| File | Contents |
|---|---|
| `Security_Events.csv` | Windows Security log (logons, accounts, tasks) |
| `Sysmon_Events.csv` | Sysmon process / registry / network / file events |
| `Wazuh_Alerts.json` | Wazuh alerts (one JSON object per line) |

All data is fictional. Times are the evening of **2026-10-20** (24-hour clock).

Open the CSVs in Excel (**Data → From Text/CSV**). For the JSON, open it in a text editor,
or in Excel use **Data → Get Data → From JSON**.

> The attacker's actions appear under `ctmadmin` because, in the live lab, the simulation
> runs from the admin account. Treat `ctmadmin` as the account the intruder controlled after
> logging in as `j.santos`.
