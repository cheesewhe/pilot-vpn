# vpn-project

Personal Contabo VPS infrastructure: hardening, observability, backups, core DNS, swappable VPN backend, Management API, and clients (CLI / Telegram / future Web UI).

## Layout

| Path | Role |
|------|------|
| `/opt/vpn-project` | Code, docs, tests, git |
| `/etc/vpn-project` | Deployed non-secret config |
| `/var/lib/vpn-project` | Secrets, user data, restic |
| `/var/log/vpn-project` | Project logs |

## Principles

1. Infrastructure before VPN.
2. Protocol chosen via ADR — not assumed.
3. Telegram/Web UI are API clients, not the core.
4. Dangerous changes: explain → backup → confirm → apply → verify → rollback.
5. Gate: `./tests/all.sh`

## Stages

See `docs/CHANGELOG.md` and `docs/checklists/`.
