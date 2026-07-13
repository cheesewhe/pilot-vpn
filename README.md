# vpn-project / pilot-vpn

Personal **VPN platform** on Contabo: reproducible infrastructure with hardening, observability, backups, Core DNS, and a swappable WireGuard backend — plus CLI → API → bot/UI on top.

Not “just install a VPN”. Build a small production-style service: docs, Git, restic, monitoring, logging, automation.

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
3. **CLI before API**; Telegram/Web UI are API clients only.
4. One mature node before HA.
5. Dangerous changes: explain → backup → confirm → apply → verify → rollback.
6. Gate: `./tests/all.sh`

## Roadmap

See [`docs/ROADMAP.md`](docs/ROADMAP.md). History: [`docs/CHANGELOG.md`](docs/CHANGELOG.md).
