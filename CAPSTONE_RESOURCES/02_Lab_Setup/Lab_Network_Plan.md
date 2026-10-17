# Lab Network Plan + VM Specifications

## Host computer (your laptop / PC)
- **Minimum:** 8 GB RAM, 4 CPU cores, 100 GB free disk, VT-x / AMD-V **ON**
- **Better:** 16 GB RAM, 6+ cores, SSD

> If a member's PC is too small, the team uses **one** "primary lab" on the strongest PC and
> shares the screen during calls.

## VM 1 — Wazuh server (imported from the Wazuh OVA)

| Setting | Value |
|---|---|
| Name in VirtualBox | `CTM-Wazuh` |
| RAM / CPU | 4096 MB (8192 if you can) / 2–4 CPUs |
| Display | Graphics Controller = VMSVGA |
| Adapter 1 | NAT (internet / updates) |
| Adapter 2 | Host-only Adapter (lab network) |
| Login | `wazuh-user` / `wazuh` |
| Dashboard | `https://<WAZUH-IP>` (`admin` / `admin`) |

## VM 2 — Windows endpoint (the "victim" workstation)

| Setting | Value |
|---|---|
| Name in VirtualBox | `CTM-WIN01` |
| Hostname (inside) | `WIN-CTM-01` |
| Local admin user | `ctmadmin` (choose your own password) |
| RAM / CPU / Disk | 4096 MB / 2 CPUs / 64 GB |
| Windows 11 needs | EFI + Secure Boot + TPM 2.0 (VirtualBox 7 sets these when you choose "Windows 11 (64-bit)") |
| Adapter 1 | NAT |
| Adapter 2 | Host-only Adapter (same one as the Wazuh VM) |

## Host-only network
VirtualBox → **Tools → Network → Host-only Networks**

- Default network: `192.168.56.0/24`, DHCP server **ON**
- Host PC: `192.168.56.1`
- VMs get IPs from DHCP (usually `192.168.56.101` and up)

**Find the IPs:**
- Wazuh VM → `ip -4 addr` (look for `192.168.56.x`)
- Windows VM → `ipconfig` (look for `192.168.56.x`)

## Fill this in (copy into your Team Charter)

```
Wazuh server IP     : 192.168.56.____
Windows endpoint IP : 192.168.56.____
Wazuh version       : 4.____.____   (Dashboard > top-left menu > About)
Primary lab host    : ______________________ (member name)
```

## Ports that must be open (Windows → Wazuh)

| Port | Purpose |
|---|---|
| 1514/TCP | agent event data |
| 1515/TCP | agent enrollment |
| 443/TCP | dashboard (from your host browser) |

## Diagram

```
+-------------------- HOST PC (VirtualBox) --------------------+
|                                                              |
|   +---------------+   host-only 192.168.56.0/24  +---------+ |
|   |  CTM-WIN01    |------------------------------| CTM-    | |
|   |  Windows +    |  agent -> 1514/1515 TCP      | Wazuh   | |
|   |  Sysmon +     |                              | Manager | |
|   |  Wazuh agent  |                              | Indexer | |
|   +---------------+                              | Dashbrd | |
|          |  NAT (internet)                       +---------+ |
|          |                         browser -> https:443      |
+--------------------------------------------------------------+
```
