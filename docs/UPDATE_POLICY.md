# UPDATE_POLICY

**Status:** draft accepted for planning; enforce from Stage 1.

| Component | Policy | Notes |
|-----------|--------|-------|
| Ubuntu security (LTS) | Automatic via `unattended-upgrades` | Already enabled at baseline |
| Kernel reboot | Manual | Maintenance window + checklist + SSH verify |
| fail2ban / UFW rules | Manual only | Backup + confirm |
| Core DNS | Manual | `./tests/dns.sh` after change |
| VPN backend | Manual | Full `./tests/all.sh` |
| Prometheus / Grafana / exporters | Manual | Pin versions; major = separate window |
| restic | Manual | Verify backup + restore smoke |
| Management API / bot | Manual | API contract tests |
| Docker (if introduced) | Manual | Images pinned by tag/digest; ADR required |

## Principle

**OS security patches: automatic. Anything that can break remote access or the tunnel: manual + checklist + tests.**

## Reboot checklist (kernel)

1. restic snapshot + git commit
2. `needrestart` / check `/var/run/reboot-required`
3. Reboot
4. `./tests/ssh.sh` from a second session path
5. Start project services; `./tests/all.sh`
6. Update INVENTORY kernel field
