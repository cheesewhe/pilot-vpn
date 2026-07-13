# ROADMAP

**Mission:** build a personal secure VPN **platform** — automation, observability, and reproducible infrastructure — able to grow from one MacBook to dozens of devices and (later) multiple servers.

## Done

| Stage | Result |
|-------|--------|
| 0–5 | Hardening, monitoring, restic, reputation, Unbound, WG ADR |
| 1.5 | Private GitHub + deploy key |
| 6 | WireGuard production (`wg0`, macbook peer, DNS/MTU/docs) |
| 6.5 | `./tests/network.sh` + client validation checklist |
| 7 | Firewall/NAT/IPv6 polish (single MASQUERADE via wg-quick) |
| 7.5 | Secrets policy + categorized dirs (`docs/SECRETS.md`) |

## Next

### Stage 8 — `vpnctl` CLI (heart of the project)

```text
vpnctl add-user | add-device | revoke | list | export | stats | doctor
```

Users are **entities**; devices are WireGuard peers. Bot/API never talk to WG directly.

### Stage 9 — REST API

Thin layer over the same functions as `vpnctl`.

### Stage 10 — Telegram bot

```text
Telegram → REST API → vpnctl → WireGuard
```

### Later

- VPN metrics exporter + Grafana + Alertmanager
- Optional panel
- HA / second node (only after one mature node)
- nftables, CrowdSec, blackbox, Loki

## Data model

See `docs/DATA_MODEL.md` — User 1—\* Device \*—1 Server.

## Philosophy

1. Foundation before VPN; **validation before automation**.
2. CLI before API before bot.
3. One mature node before HA.
4. Gate: `./tests/all.sh` and `./tests/network.sh`.
