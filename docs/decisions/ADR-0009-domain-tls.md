# ADR-0009: Custom domain and public TLS (deferred)

- **Status:** accepted (defer)
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Stage 3.5 evaluated whether the node needs a personal domain and TLS certificate before VPN selection. Provider hostname `vmi3413547.contaboserver.net` already has PTR for IPv4/IPv6. Forward-A for that name is inconsistent across public resolvers. No public HTTP(S) service exists yet.

## Decision

**Do not** register a custom domain or issue public TLS certificates in Stage 3.5–4.

- Operate by **IP** for SSH and for the first VPN backend unless the Stage 5 protocol ADR requires a hostname.
- If Stage 5 chooses a transport that benefits from a real domain (e.g. TLS/REALITY SNI), open a follow-up ADR to pick registrar + ACME (localhost/DNS-01 preferred; no needless public :443).
- Contabo default PTR is sufficient until then.

## Consequences

- Simpler attack surface (no :80/:443)
- Client configs use IP until a domain ADR
- Must revisit before any public reverse-proxy or branded endpoints

## Alternatives considered

| Option | Why not now |
|--------|-------------|
| Buy domain immediately | Premature before protocol choice |
| Use Contabo hostname in clients | Unstable forward-A; ugly; provider-tied |
| Public Caddy/nginx + Let's Encrypt | Adds public ports without VPN need |

## References

- `docs/REPUTATION.md`
- `docs/decisions/ADR-0007-vpn-protocol.md`
- Stage 4 Core DNS (ADR-0005)
