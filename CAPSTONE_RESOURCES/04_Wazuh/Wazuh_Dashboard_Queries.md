# Wazuh Dashboard — Copy/Paste Search Queries (DQL)

**Where to paste:** Wazuh dashboard → **Threat Hunting** (or Discover) → **Events** tab →
search bar. Set the time picker (top right) to cover your activity, e.g. "Last 24 hours".

> **Tip:** click the `>` arrow on any event to see all its fields.

## General

```
agent.name:"WIN-CTM-01"
```
All events from our Windows endpoint.

```
rule.groups:"ctm_capstone"
```
Everything our custom capstone rules detected.

```
rule.level >= 8
```
Only medium / high severity alerts.

## Authentication

```
data.win.system.eventID:"4625"
```
Failed logons.

```
data.win.system.eventID:"4625" and data.win.eventdata.targetUserName:"j.santos"
```
Failed logons for a specific user.

```
data.win.system.eventID:"4624" and not data.win.eventdata.targetUserName:*$
```
Successful logons (exclude computer accounts ending with `$`).

```
rule.id:"100201"
```
Brute force alert (custom rule).

## Accounts

```
data.win.system.eventID:("4720" or "4732")
```
User created / added to group.

## Persistence

```
data.win.system.eventID:"4698"
```
Scheduled tasks.

```
rule.id:"100207"
```
Registry Run keys (Sysmon 13).

## Execution

```
data.win.system.eventID:"1" and data.win.system.providerName:"Microsoft-Windows-Sysmon"
```
Sysmon process creation.

```
data.win.eventdata.image:*powershell.exe
```
PowerShell processes.

```
rule.id:"100205"
```
Encoded PowerShell (custom rule).

```
data.win.system.eventID:"4104"
```
PowerShell script blocks (decoded code).

## Network / DNS

```
data.win.system.eventID:"3"
```
Sysmon network connections.

```
data.win.system.eventID:"22"
```
Sysmon DNS queries.

## Files

```
rule.groups:"syscheck"
```
File Integrity Monitoring (FIM) events.

```
rule.id:"100208"
```
FIM on the finance folder (custom rule).

```
rule.id:"100210"
```
Archive files created.

## Malware

```
data.win.system.eventID:("1116" or "1117")
```
Defender detections.

## MITRE

```
rule.mitre.id:*
```
Any alert mapped to MITRE ATT&CK.

---

## Useful columns to add
Click a field name → "Add" / toggle column:

`timestamp`, `rule.id`, `rule.level`, `rule.description`, `data.win.system.eventID`,
`data.win.eventdata.targetUserName`, `data.win.eventdata.commandLine`,
`data.win.eventdata.image`

## Server commands
Wazuh VM console, login `wazuh-user` / `wazuh`:

```bash
sudo systemctl status wazuh-manager        # is the manager running?
sudo systemctl restart wazuh-manager        # after editing rules
sudo /var/ossec/bin/agent_control -l         # list agents + status
sudo /var/ossec/bin/wazuh-logtest            # test a log against rules
sudo tail -f /var/ossec/logs/alerts/alerts.json   # live alerts
sudo tail -n 50 /var/ossec/logs/ossec.log    # manager errors (rule typos!)
```
