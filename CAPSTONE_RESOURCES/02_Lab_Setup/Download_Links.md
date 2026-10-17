# Download List

Everything is **free**. Download on Day 1 morning.

> **Tip:** the downloads are large (about 12 GB total). Start them first, then read the
> guide while they finish.

## 1. Oracle VirtualBox 7.x (+ matching Extension Pack)
<https://www.virtualbox.org/wiki/Downloads>
- Install "VirtualBox platform package" for your host OS.
- Optional: Extension Pack (same version number).

## 2. Wazuh Virtual Machine (OVA) — all-in-one SIEM server
<https://documentation.wazuh.com/current/deployment-options/virtual-machine/virtual-machine.html>
- Download the `.ova` file listed on that page (~5 GB).
- Default VM console login: `wazuh-user` / `wazuh`
- Default dashboard login: `admin` / `admin`

## 3. Windows endpoint (choose ONE)
- **(a) Windows 11 Enterprise Evaluation (90 days) — recommended**
  <https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise>
- **(b) Windows Server 2022 Evaluation (180 days)** — use this if your PC cannot run
  Windows 11 (no TPM / Secure Boot needed)
  <https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022>
- Pick the ISO, 64-bit, English (United States).

## 4. Sysmon (Microsoft Sysinternals) — download INSIDE the Windows VM
<https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon>
Direct: <https://download.sysinternals.com/files/Sysmon.zip>
*(`Install_Sysmon.ps1` downloads this for you automatically.)*

## 5. Wazuh Windows agent
Downloaded automatically by `04_Wazuh\Install_Wazuh_Agent.ps1`.
Manual docs:
<https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-windows.html>

---

## Reference sites (bookmark these)

| Site | URL |
|---|---|
| MITRE ATT&CK | <https://attack.mitre.org> |
| CyberChef (decode) | <https://gchq.github.io/CyberChef/> |
| Windows audit events | <https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings> |
| Wazuh ruleset docs | <https://documentation.wazuh.com/current/user-manual/ruleset/index.html> |
| Wazuh Windows events | <https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/index.html> |
