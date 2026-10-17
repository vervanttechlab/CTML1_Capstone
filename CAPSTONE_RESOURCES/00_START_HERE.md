# Start Here

## Cyber Threat Monitoring Level 1 — 5-Day Guided Capstone
### "Operation Night Ledger" — Build, Monitor, Detect, Respond

**Welcome, team!** This one folder has everything your team needs for all 5 days.
Upload the whole folder (or `CAPSTONE_RESOURCES.zip`) to your team's shared drive
(Google Drive / OneDrive / Teams). Everyone works from it.

> 🌐 **Reading this on GitHub Pages?** The full guide with a sidebar navigator is the
> published site (`index.html`). The printable version is
> [`01_Guide/Capstone_Guide_CTM_L1.pdf`](01_Guide/Capstone_Guide_CTM_L1.pdf).

---

## Step 1 — Read the guide first

- **Web / GitHub Pages:** the published site (`index.html`)
- **Printable:** [`01_Guide/Capstone_Guide_CTM_L1.pdf`](01_Guide/Capstone_Guide_CTM_L1.pdf)

---

## What is in each folder (use them in this order)

| Folder | Day | Contents |
|---|---|---|
| **01_Guide** | All | The capstone guide (PDF + web) |
| **02_Lab_Setup** | 1 | `Download_Links.md`, `Lab_Network_Plan.md`, `Preflight_Check.ps1` |
| **03_Windows_Logging** | 2 | Seed / audit / Sysmon scripts + config, Event Viewer custom views, Event ID cheat sheet |
| **04_Wazuh** | 3 | Agent installer, ossec additions, `local_rules.xml`, dashboard queries |
| **05_Attack_Simulation** | 4 | `Scenario_Brief.md`, `Run_Scenario.ps1`, `Cleanup_Scenario.ps1` |
| **06_Backup_Dataset** | 4 (Plan B) | `Security_Events.csv`, `Sysmon_Events.csv`, `Wazuh_Alerts.json` |
| **07_Team_Templates** | All | Charter, stand-up log, triage tracker, worksheet, report, presentation |
| **08_Assessment** | 5 | Grading rubric, peer evaluation |

### 03_Windows_Logging — Event Viewer custom views
Four ready-made views to import (`EventViewer_Custom_Views\`):
`CV1 Authentication`, `CV2 Account Changes`, `CV3 Persistence and Execution`,
`CV4 PowerShell and Defender`.

---

## Golden rules

1. Only run the scripts **inside your Windows lab VM** — never on your personal or work computer.
2. Run scripts in PowerShell **"Run as Administrator"**. If scripts are blocked, run this first
   (in that same window only):
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
3. Take a VirtualBox **snapshot** at the end of every day.
4. **Screenshot every checkpoint** — screenshots are your evidence.
5. Stuck for more than 15 minutes? Check the Troubleshooting page in the guide, then ask your
   instructor in the team channel.
