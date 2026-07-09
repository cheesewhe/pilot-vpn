# LOGGING

**Status:** policy draft (Stage 0); enforcement in Stage 3.

## Goals

- Enough signal to debug SSH, firewall, VPN, API
- Prevent disk fill (VPN access logs grow fast)
- Keep sensitive connection detail retention short

## Channels

| Source | Destination | Retention (initial) |
|--------|-------------|---------------------|
| systemd services | journald | 14 days or 500M (tighten in Stage 3) |
| Project app logs | `/var/log/vpn-project/` + logrotate | 7–14 days |
| UFW / fail2ban | journald / their defaults | align to 14 days |
| VPN access logs | `/var/log/vpn-project/` or service dir | **7 days max** verbose |

## Rules

1. Prefer journald for unit stdout/stderr.
2. Any high-volume access log must have logrotate from day one of that service.
3. Do not ship logs off-box in v1 without ADR.
4. Grafana disk alerts once monitoring exists (Stage 2).

## Stage 3 deliverables

- journald persistent config snippet (size/time caps)
- logrotate templates under `templates/`
- document exact paths per service in INVENTORY
