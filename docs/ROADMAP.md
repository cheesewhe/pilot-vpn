# ROADMAP

**Mission:** build a personal secure VPN **platform** — automation, observability, and reproducible infrastructure — not just “install WireGuard”.

## Done (platform foundation)

| Stage | Result |
|-------|--------|
| 0 | Baseline, FHS layout, threat model, git |
| 1 | Swap, UFW, SSH key-only, fail2ban |
| 1.5 | Private GitHub remote + deploy key |
| 2 | node_exporter / Prometheus / Grafana (localhost + SSH tunnel) |
| 3 | restic + daily timer + journald/logrotate |
| 3.5 | IP reputation / PTR / DNSBL; domain+TLS deferred (ADR-0009) |
| 4 | Unbound Core DNS on loopback |
| 5 | Protocol ADR: **WireGuard primary** |
| 6 | WireGuard production (`wg0`, macbook, DNS/MTU/docs) |

## Next

### Stage 7 — Management CLI (`vpnctl`)

Deliverable: one server + one client that is usable day-to-day.

- `wg0`, subnet, UFW `51820/udp`
- IPv4 + IPv6 policy
- DNS via Unbound (VPN ACL)
- MTU tuning
- Client: full-tunnel + documented split-tunnel option
- Kill-switch guidance (macOS/iOS/Android)
- QR + `.conf` for first peer
- Gate: `./tests/all.sh` including vpn/dns-leak/mtu/routing

### Stage 7 — Management CLI (`vpnctl`)

Before any API:

```text
vpnctl add-user | revoke | list | gen-config | stats
```

CLI owns the operational truth over peers/files.

### Stage 8 — REST API

Thin HTTP/unix-socket layer calling the same functions as `vpnctl`  
(`POST/DELETE/GET /users`, `GET /stats`).

### Stage 9 — Telegram bot

Bot talks **only** to the API — never to WireGuard directly.

```text
Telegram → REST API → vpnctl → WireGuard
```

### Stage 10 — VPN metrics

WireGuard exporter → Prometheus → Grafana  
(`peer_count`, handshakes, rx/tx, online users).  
Alertmanager / Telegram alerts when useful (disk, backup failed, brute force) — after exporter works.

### Stage 11 — Optional panel

Web UI (peers, traffic, create config, QR, revoke) — only after domain/TLS ADR if public HTTPS is desired. Prefer SSH-tunnel or private access first.

## Explicitly later (not before mature single-node)

- HA / second VPS / failover
- nftables migration (UFW is fine until WG+CLI are stable)
- CrowdSec alongside fail2ban
- Blackbox exporter (SSH/DNS/Prometheus/VPN probes)
- Loki for centralized logs

## Philosophy

Prefer one mature, reproducible node (docs + git + restic + tests + CLI) before multi-node HA.
