# CHANGELOG

All notable stage completions and host changes.

## 2026-07-09 — Stage 0 complete

### What

- Created project layout under `/opt/vpn-project`, `/etc/vpn-project`, `/var/lib/vpn-project`, `/var/log/vpn-project`
- Wrote baseline docs: SERVER_BASELINE, INVENTORY, THREAT_MODEL, NETWORK, SAFETY, UPDATE_POLICY, LOGGING, RESTORE (draft)
- Added ADR template + ADR-0006 secrets layout
- Added test skeleton and helper scripts
- Initialized git repository

### Why

Establish infrastructure-as-a-project before hardening or VPN.

### Files

- `/opt/vpn-project/**` (new)
- `/etc/vpn-project/README.md`
- `/var/lib/vpn-project/**`

### Verify

- `test -d /opt/vpn-project/docs`
- `git -C /opt/vpn-project status`
- `./tests/all.sh` (Stage 0 subset; VPN tests skip)

### Rollback

- Remove `/opt/vpn-project`, `/etc/vpn-project`, `/var/lib/vpn-project`, `/var/log/vpn-project` if abandoning project (does not affect OS services; none changed)
