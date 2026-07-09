# SERVER_BASELINE

Snapshot of the clean Contabo VPS before infrastructure changes.

- **Captured:** 2026-07-09T13:02:45Z
- **Host:** vmi3413547.contaboserver.net (`vmi3413547`)
- **Provider:** Contabo, EU, KVM
- **Raw audit:** `/tmp/vpn-audit-raw.txt` (ephemeral); keep this document as the durable record.

## Operating system

| Item | Value |
|------|-------|
| OS | Ubuntu 24.04.4 LTS (noble) |
| Kernel | 6.8.0-106-generic x86_64 (`/var/run/reboot-required` present for 6.8.0-134-generic) |
| Virtualization | KVM (QEMU) |
| Machine ID | f7690663642c4560b1877f3f598ab871 |

## Resources

| Item | Value |
|------|-------|
| CPU | 6 × AMD EPYC (KVM), 1 thread/core |
| RAM | ~11 GiB (12541513728 bytes); ~10 GiB available at audit |
| Swap | **none** |
| Disk | 200G SSD (`/dev/sda`), root ext4 ~193G, ~190G free (2% used) |
| Boot | `/boot` 881M, `/boot/efi` 105M |

## Network

| Item | Value |
|------|-------|
| Interface | `eth0` UP |
| IPv4 | 173.249.39.129/24, gateway 173.249.39.1 |
| IPv6 | 2a02:c207:2341:3547::1/64, default via fe80::1 onlink |
| DNS (provider) | 195.179.224.53, 209.126.15.53 via systemd-resolved stub |
| ip_forward v4/v6 | 0 / 0 |
| Netplan | `/etc/netplan/50-cloud-init.yaml` (cloud-init managed) |

## SSH

| Item | Value |
|------|-------|
| Listen | `0.0.0.0:22`, `[::]:22` (sshd + socket activation) |
| PermitRootLogin | yes |
| PubkeyAuthentication | yes |
| PasswordAuthentication | **conflicting drop-ins**: `50-cloud-init.conf` = yes, `60-cloudimg-settings.conf` = no |
| Authorized keys | 2 × ED25519 (`zhuk17`, `mac-contabo`) |
| Interactive auth | KbdInteractiveAuthentication no |

**Risk:** ambiguous PasswordAuthentication across drop-ins; must be made explicit in Stage 1 without locking out key access. Serial console `ttyS0` is active (Contabo emergency path).

## Firewall

| Item | Value |
|------|-------|
| UFW | inactive |
| iptables INPUT/FORWARD/OUTPUT | ACCEPT (empty) |
| nftables | not meaningfully configured |

**Risk:** host fully exposed on any service that starts listening.

## Listening ports (audit)

| Address | Port | Process |
|---------|------|---------|
| 0.0.0.0 / :: | 22/tcp | sshd |
| 127.0.0.53 / 127.0.0.54 | 53/tcp+udp | systemd-resolved |
| 127.0.0.1 | 34335, 41307/tcp | node (Cursor IDE server) |

No public VPN, HTTP, or monitoring listeners.

## Users

- Interactive: `root` only (UID 0). No human sudo user yet.
- No project service users yet.

## Running services (notable)

cron, dbus, fwupd, getty, ModemManager, multipathd, polkit, rsyslog, serial-getty@ttyS0, ssh, systemd-{journald,logind,networkd,resolved,timesyncd,udevd}, udisks2, unattended-upgrades, user@0.

**Candidates to review in Stage 1:** ModemManager (unnecessary on VPS), multipathd (often unused on single-disk VPS).

## Packages (VPN / monitoring / backup)

None of: wireguard, openvpn, xray, fail2ban, prometheus, grafana, docker, restic, borg, unbound, coredns.

## Unattended upgrades

- Package installed; unit **enabled**.
- Confirm policy and reboot handling in Stage 1 / UPDATE_POLICY.

## Project layout created (Stage 0)

| Path | Role |
|------|------|
| `/opt/vpn-project` | Code, docs, tests, git |
| `/etc/vpn-project` | Non-secret deployed config |
| `/var/lib/vpn-project` | Secrets, user data, restic |
| `/var/log/vpn-project` | Project logs |

## Risks identified (pre-hardening)

1. No firewall — any future misbound service is public.
2. SSH PasswordAuthentication drop-in conflict.
3. Root-only access model — blast radius of key compromise is total.
4. No swap — OOM risk under memory pressure.
5. Provider DNS only — no project-controlled resolver yet.
6. No monitoring / backups / inventory process yet (addressed by this project).
7. Datacenter IP reputation unknown (Stage 3.5).

## Next stage

Stage 1 — Hardening (requires explicit confirmation before SSH/UFW changes).
