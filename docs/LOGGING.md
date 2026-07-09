# LOGGING

**Status:** enforced (Stage 3)  
**Related:** ADR-0004

## Goals

- Enough signal to debug SSH, firewall, VPN, API
- Prevent disk fill
- Keep sensitive connection detail retention short

## Channels

| Source | Destination | Retention |
|--------|-------------|-----------|
| systemd services | journald (persistent) | **14 days** or **500M** (`SystemMaxUse`) |
| Project app logs | `/var/log/vpn-project/*.log` | **14 days** via `/etc/logrotate.d/vpn-project` |
| UFW / fail2ban | journald / package defaults | align to journald caps |
| VPN access logs (future) | `/var/log/vpn-project/` | **7 days max** verbose when VPN lands |

## Config files

- `/etc/systemd/journald.conf.d/vpn-project.conf`
- `/etc/logrotate.d/vpn-project`

## Rules

1. Prefer journald for unit stdout/stderr.
2. High-volume access logs must have logrotate from day one of that service.
3. Do not ship logs off-box in v1 without ADR.
4. Disk alerts via Grafana once thresholds are tuned.
