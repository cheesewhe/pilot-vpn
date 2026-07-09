# ADR-0002: Host firewall (UFW)

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Baseline host had no active firewall (UFW inactive, iptables ACCEPT). Any future misbound service would be public. Threat model requires minimal public exposure.

## Decision

Use **UFW** with:

- `IPV6=yes`
- Default: deny incoming, allow outgoing, routed disabled (until VPN NAT)
- Allow TCP/22 (OpenSSH) IPv4+IPv6
- Enable on boot
- VPN ports added only when a backend is deployed (Stage 6)

## Consequences

- Public attack surface limited to SSH until VPN
- Risk of lockout on misconfiguration — mitigated by allow-SSH-before-enable and Contabo serial
- Routed/forward traffic still denied until VPN stage explicitly opens it

## Alternatives considered

| Option | Why not |
|--------|---------|
| nftables raw only | More flexible but higher footgun for v1 |
| Provider panel firewall only | Incomplete; host must defend itself |
| firewalld | Non-default on Ubuntu server; no benefit here |

## References

- `docs/THREAT_MODEL.md`
- `docs/NETWORK.md`
- Stage 1 checklist
