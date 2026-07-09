# THREAT_MODEL

**Status:** accepted for v1 (Stage 0)  
**Related ADR:** decisions evolve from this model; see `docs/decisions/`.

## Assets

| Asset | Sensitivity | Notes |
|-------|-------------|-------|
| SSH access | critical | Full host control |
| OS integrity | critical | |
| Private keys / tokens | critical | `/var/lib/vpn-project/secrets` |
| User/peer credentials | high | VPN identity |
| Connection metadata / logs | medium–high | Retention limited |
| Metrics (Grafana/Prometheus) | medium | Topology + usage hints |
| Public IP reputation | medium | Past VPS failure lesson |
| Documentation / git history | medium | Must not contain secrets |

## Adversaries / threats

| Threat | Likelihood | Impact | Mitigation direction |
|--------|------------|--------|----------------------|
| Internet scanners / SSH brute force | high | high | Key-only SSH, fail2ban, UFW |
| Opportunistic exploits on exposed services | medium | high | Minimal public ports; no public Grafana |
| Admin misconfiguration / lockout | medium | high | Checklists, serial console, backups, confirm gate |
| Secret leakage via git/backups | medium | critical | FHS secrets path, .gitignore, encrypted restic |
| Single-service compromise blast radius | medium | high | Service users, least privilege, localhost binds |
| Transport blocking / DPI | medium | medium | Protocol ADR; optional second transport later |
| Bad/abused datacenter IP reputation | medium | high | Stage 3.5 checks, PTR, careful outbound |
| Disk fill via verbose VPN logs | medium | medium | Rotation + retention policy |

## Out of scope (v1)

- Nation-state targeted attacker
- Making VPN undetectable to ISP at any cost
- Multi-tenant public SaaS isolation
- Legal/compliance frameworks beyond personal use

## Design consequences

1. **Infrastructure before VPN** — reduce accidental exposure while iterating on transport.
2. **No public monitoring UI** — SSH tunnel only until a later ADR says otherwise.
3. **Secrets outside `/opt`** — `/var/lib/vpn-project/secrets`.
4. **Management API as sole mutation path** — bots/UI are clients.
5. **Protocol not assumed** — choose via ADR after reputation + core services.
6. **Confirm gate** for SSH, firewall, sysctl, destructive package changes.

## Review triggers

Revisit this document when: adding a public port, changing auth model, adding a second admin, choosing VPN protocol, or after any security incident.
