# CTM Level 1 Capstone — Operation Night Ledger

A **5-day, team-based blue-team capstone** for Cyber Threat Monitoring Level 1. Your team
builds a small monitored Windows lab, connects it to the **Wazuh** SIEM, investigates a
*simulated* intrusion, and reports the findings like a real Security Operations Center (SOC).

**Tools:** Oracle VirtualBox · Windows + Event Viewer · Sysmon · Wazuh · MITRE ATT&CK

---

## 📖 Read the guide

- **Web guide (sidebar navigator):** open **[`index.html`](index.html)** — or the published
  **GitHub Pages** site once enabled: `https://vervanttechlab.github.io/CTML1_Capstone/`
- **Printable guide:** [`CAPSTONE_RESOURCES/01_Guide/Capstone_Guide_CTM_L1.pdf`](CAPSTONE_RESOURCES/01_Guide/Capstone_Guide_CTM_L1.pdf)
- **Quick start:** [`CAPSTONE_RESOURCES/00_START_HERE.md`](CAPSTONE_RESOURCES/00_START_HERE.md)

## 🗂️ What's inside — `CAPSTONE_RESOURCES/`

| Folder | Day | Contents |
|---|---|---|
| `01_Guide` | All | Guide (PDF) — web version is `index.html` at the repo root |
| `02_Lab_Setup` | 1 | Download links, network plan, `Preflight_Check.ps1` |
| `03_Windows_Logging` | 2 | Seed / audit / Sysmon scripts + config, Event Viewer custom views, Event ID cheat sheet |
| `04_Wazuh` | 3 | Agent installer, ossec additions, `local_rules.xml`, dashboard queries |
| `05_Attack_Simulation` | 4 | Scenario brief, `Run_Scenario.ps1`, `Cleanup_Scenario.ps1` |
| `06_Backup_Dataset` | 4 (Plan B) | `Security_Events.csv`, `Sysmon_Events.csv`, `Wazuh_Alerts.json` |
| `07_Team_Templates` | All | Charter, stand-up log, triage tracker, worksheet, report, presentation |
| `08_Assessment` | 5 | Grading rubric, peer evaluation |

## 🗓️ The five days

1. **Build the lab** — two VMs on one host-only network, snapshots taken.
2. **Windows logging** — audit policy, Sysmon and PowerShell logging; Event Viewer views.
3. **Wazuh SIEM** — agent ACTIVE, custom detection rules, logs flowing.
4. **Attack & investigate** — triage alerts, confirm in Event Viewer, build the timeline.
5. **Report & present** — incident report and team presentation.

## 🚀 Enable GitHub Pages
Repository **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
branch `main`, folder `/ (root)`. The `index.html` guide becomes your published site.

## ⚠️ Safety
- Run every script **only inside your lab virtual machine** — never on a personal or work PC.
- The Day 4 "attack" is a **harmless simulation**; no real malware is used (the antivirus
  test uses the standard, non-malicious EICAR string).

---
*Built for the Vervant Tech Lab CTM Level 1 program. All company names and data are fictional.*
