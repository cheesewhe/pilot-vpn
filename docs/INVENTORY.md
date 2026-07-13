# INVENTORY

Living inventory of the node. Update on every stage.

**Last updated:** 2026-07-13 (Stage 7.5)

## Host

| Field | Value |
|-------|-------|
| Provider | Contabo |
| Region | EU |
| Hostname | vmi3413547 / vmi3413547.contaboserver.net |
| OS | Ubuntu 24.04.4 LTS |
| Kernel | 6.8.0-134-generic |
| Arch | x86_64 |
| Virt | KVM |
| CPU | 6 vCPU AMD EPYC |
| RAM | ~11 GiB |
| Swap | 4 GiB `/swapfile` |
| Disk | 200G SSD, ~190G free on `/` |

## Addresses

| Family | Address | Notes |
|--------|---------|-------|
| IPv4 | 173.249.39.129/24 | Public |
| IPv4 GW | 173.249.39.1 | |
| IPv6 | 2a02:c207:2341:3547::1/64 | Public |
| IPv6 GW | fe80::1 | onlink |
| PTR IPv4 | vmi3413547.contaboserver.net | Stage 3.5 verified |
| PTR IPv6 | vmi3413547.contaboserver.net | Stage 3.5 verified |
| ASN | AS51167 CONTABO | RIPE |
| Domain | none (deferred ADR-0009) | |
| TLS certs | none | |

## DNS

| Role | Value |
|------|-------|
| Host resolver | systemd-resolved → Contabo DNS |
| Project Core DNS | Unbound 1.19.2 | 127.0.0.1:53 / ::1:53 (ADR-0005) |

## Public services / ports

| Port | Proto | Service | Auth | Notes |
|------|-------|---------|------|-------|
| 22 | tcp | sshd | ED25519 keys only | UFW allowed; PasswordAuth no |
| 51820 | udp | WireGuard | peer keys | UFW allowed |

Loopback-only: systemd-resolved :53, Cursor node ports, node_exporter :9100, Prometheus :9090, Grafana :3000.

## Firewall

| Item | Value |
|------|-------|
| UFW | active, IPV6=yes |
| Default | deny in, allow out, routed disabled |
| Allow | 22/tcp (OpenSSH) v4+v6 |

## Installed project components

| Component | Status | Location |
|-----------|--------|----------|
| vpn-project tree | Stage 0–1.5 | `/opt/vpn-project` |
| Git remote | private | `git@github.com:cheesewhe/pilot-vpn.git` |
| Git deploy key | present | `/var/lib/vpn-project/secrets/git_deploy_ed25519` |
| Runtime dirs | Stage 0 | `/etc`, `/var/lib`, `/var/log` vpn-project |
| fail2ban | active, jail sshd | `/etc/fail2ban/jail.d/vpn-project-sshd.conf` |
| UFW | active | ADR-0002 |
| SSH hardening | active | `/etc/ssh/sshd_config.d/00-vpn-project-hardening.conf` |
| ModemManager | masked | Stage 1 |
| restic | 0.16.4 active | `/var/lib/vpn-project/restic/repo` + daily timer |
| node_exporter | 1.11.1 active | 127.0.0.1:9100 |
| Prometheus | 3.13.0 active | 127.0.0.1:9090 |
| Grafana | 13.1.0 active | 127.0.0.1:3000 (SSH tunnel) |
| Core DNS | not installed | Stage 4 |
| VPN backend | WireGuard wg0 active | UDP 51820, peer macbook |
| Management API | not installed | Stage 7 |

## Users (OS)

| User | Role |
|------|------|
| root | sole interactive admin (key-only) |

## VPN / API users

| User | Devices |
|------|--------|
| owner | macbook (10.66.0.2) |

See `docs/DATA_MODEL.md`.

## Backup repositories

| Item | Value |
|------|-------|
| restic repo | `/var/lib/vpn-project/restic/repo` (encrypted) |
| password file | `/var/lib/vpn-project/secrets/password_restic` |
| schedule | `vpn-project-backup.timer` ~03:30 |
| manifests | `/opt/vpn-project/backups/manifests/` (pointers only) |

## Certificates

None.

## IP reputation

See `docs/REPUTATION.md`. DNSBL (Spamhaus ZEN, SpamCop, SORBS, Barracuda, CBL): **clean** as of 2026-07-09. Manual AbuseIPDB/Talos re-check from browser recommended periodically.
