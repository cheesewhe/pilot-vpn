# NETWORK

Living network map. Update when ports or services change.

**Last updated:** 2026-07-09 (Stage 3.5)

## Current (Stage 1)

```mermaid
flowchart LR
  Admin[Admin_MacBook]
  Internet[Internet]
  UFW[UFW_deny_in]
  SSH[sshd_key_only]
  VPS[Contabo_VPS]
  Admin -->|SSH_22_ED25519| UFW --> SSH
  VPS -->|default_route| Internet
  VPS -->|DNS_to_provider| ProviderDNS[Contabo_DNS]
```

### Interfaces

- `lo`: 127.0.0.1/8, ::1/128
- `eth0`: 173.249.39.129/24, 2a02:c207:2341:3547::1/64

### Public exposure

- TCP/22 SSH only (UFW allow; PasswordAuthentication no)

### Not yet present

- VPN tunnel interface
- Project DNS (Unbound/CoreDNS)
- Prometheus/Grafana on 127.0.0.1 (Stage 2) — access via SSH tunnel
- Management API (planned localhost / unix socket)

## Target architecture (after Stage 6+)

```mermaid
flowchart TB
  Mac[MacBook_clients]
  Phone[Mobile_clients]
  Admin[Admin_SSH]
  UFW[UFW]
  SSH[sshd]
  VPN[VPN_backend_TBD]
  DNS[Core_DNS]
  API[Management_API_localhost]
  Prom[Prometheus]
  Graf[Grafana_SSH_tunnel]
  Net[Internet]

  Mac -->|VPN_port| UFW --> VPN
  Phone -->|VPN_port| UFW
  Admin -->|TCP_22| UFW --> SSH
  VPN --> DNS
  VPN --> Net
  DNS --> Net
  Prom --> Graf
  API --> VPN
```

## Port policy

| Stage | Port | Proto | Source | Service |
|-------|------|-------|--------|---------|
| 1 (now) | 22 | tcp | any (tighten later) | sshd + UFW default deny |
| 2 (now) | 9100/9090/3000 | tcp | localhost only | node_exporter / Prometheus / Grafana |
| 4 | — | — | localhost / VPN subnet | Core DNS |
| 6 | TBD | TBD | any or restricted | VPN backend (ADR-0007) |
| 7 | — | — | localhost | Management API |

## Notes

- IPv6 is enabled end-to-end on the host; leak policy will be defined with VPN + Core DNS.
- ip_forward remains 0 until VPN NAT requires it (Stage 6, with confirm).


## Reputation

See `docs/REPUTATION.md` and ADR-0009 (domain/TLS deferred).
