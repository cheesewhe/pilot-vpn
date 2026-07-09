# INVENTORY

Living inventory of the node. Update on every stage.

**Last updated:** 2026-07-09 (Stage 1)

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
| PTR IPv4 | TBD (Stage 3.5) | |
| Domain | none yet | Stage 3.5 decision |
| TLS certs | none | |

## DNS

| Role | Value |
|------|-------|
| Host resolver | systemd-resolved → 195.179.224.53, 209.126.15.53 |
| Project Core DNS | not deployed | Stage 4 |

## Public services / ports

| Port | Proto | Service | Auth | Notes |
|------|-------|---------|------|-------|
| 22 | tcp | sshd | ED25519 keys only | UFW allowed; PasswordAuth no |

Loopback-only: systemd-resolved :53, Cursor node ports.

## Firewall

| Item | Value |
|------|-------|
| UFW | active, IPV6=yes |
| Default | deny in, allow out, routed disabled |
| Allow | 22/tcp (OpenSSH) v4+v6 |

## Installed project components

| Component | Status | Location |
|-----------|--------|----------|
| vpn-project tree | Stage 0–1 | `/opt/vpn-project` |
| Runtime dirs | Stage 0 | `/etc`, `/var/lib`, `/var/log` vpn-project |
| fail2ban | active, jail sshd | `/etc/fail2ban/jail.d/vpn-project-sshd.conf` |
| UFW | active | ADR-0002 |
| SSH hardening | active | `/etc/ssh/sshd_config.d/00-vpn-project-hardening.conf` |
| ModemManager | masked | Stage 1 |
| restic | not installed | Stage 3 |
| Prometheus/Grafana | not installed | Stage 2 |
| Core DNS | not installed | Stage 4 |
| VPN backend | not chosen | Stage 5–6 |
| Management API | not installed | Stage 7 |

## Users (OS)

| User | Role |
|------|------|
| root | sole interactive admin (key-only) |

## VPN / API users

None.

## Backup repositories

File manifests under `/opt/vpn-project/backups/manifests/` (restic planned Stage 3).

## Certificates

None.

## IP reputation

Not checked yet — Stage 3.5.
