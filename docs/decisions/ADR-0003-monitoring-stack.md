# ADR-0003: Monitoring stack (native binaries, localhost only)

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Need VPS observability before VPN. Threat model forbids public Grafana/Prometheus.

## Decision

Install **native upstream binaries** (no Docker in v1):

| Component | Version | Bind |
|-----------|---------|------|
| node_exporter | 1.11.1 | `127.0.0.1:9100` |
| Prometheus | 3.13.0 | `127.0.0.1:9090` |
| Grafana OSS | 13.1.0 | `127.0.0.1:3000` |

- Config: `/etc/vpn-project/monitoring/`
- Data: `/var/lib/vpn-project/monitoring/`
- Units: `node_exporter.service`, `prometheus.service`, `grafana.service`
- Access UI via SSH tunnel: `ssh -L 3000:127.0.0.1:3000 root@HOST`
- Admin password: `/var/lib/vpn-project/secrets/password_grafana_admin` (not in git)
- Retention: Prometheus TSDB 15d

`/var/lib/vpn-project` is mode `755` so service users can traverse; `secrets/` remains `700`.

## Consequences

- No container runtime dependency
- Manual upgrades (UPDATE_POLICY)
- Operators must use SSH tunnel for Grafana

## Alternatives considered

| Option | Why not |
|--------|---------|
| Docker Compose | Extra attack surface / dependency for v1 |
| Netdata | Heavier public-facing defaults |
| Cloud SaaS agents | Extra trust boundary |

## References

- `docs/THREAT_MODEL.md`
- `monitoring/templates/`
- `systemd/*.service`
