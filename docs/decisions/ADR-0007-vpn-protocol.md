# ADR-0007: VPN protocol — WireGuard primary

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Infrastructure (hardening, monitoring, restic, Unbound, git) is ready. Stage 5 must choose a primary VPN backend without installing it yet. Goals: stable personal encrypted access, long-lived ops, Mac/mobile clients, Management API later. Threat model rejects “undetectable to ISP at any cost”. Prior Contabo VLESS+REALITY node worked then the IP stopped being useful — camouflage did not guarantee longevity on a DC IP.

Full matrix: `docs/PROTOCOL_COMPARISON.md`.

## Decision

1. **Primary VPN backend: WireGuard** (Stage 6 install).
2. **Secondary transport: deferred** — placeholders remain under `services/xray`, `services/hysteria`, `services/tuic`. Add only via a new ADR if WG is blocked on important client networks.
3. Clients use **server IPv4** (and IPv6 if useful); no custom domain required (ADR-0009).
4. Tunnel DNS → **Unbound** on the VPN-facing address (Stage 6 extends Unbound ACL; still no public :53).
5. UFW will allow only the WireGuard UDP port (default **51820**, confirm at install).

## Consequences

- Excellent speed, simple key model for API/bot, first-class mobile apps
- WG UDP may be blocked on some networks → mitigate later with optional second transport, not by abandoning infra design
- Installation and peer scripts land in Stage 6 under `services/wireguard/`

## Alternatives considered

| Option | Why not as primary |
|--------|--------------------|
| VLESS+REALITY | Better camouflage; worse ops/surface; didn’t save previous Contabo IP |
| Hysteria2 / TUIC | Good performance niches; younger ops story |
| OpenVPN | Heavier, easier to fingerprint, awkward for API user mgmt |
| Dual-active WG+Xray from day one | Extra ports/complexity before Management API exists |

## References

- `docs/PROTOCOL_COMPARISON.md`
- `docs/THREAT_MODEL.md`
- `docs/REPUTATION.md`
- `docs/decisions/ADR-0005-dns-service.md`
- `docs/decisions/ADR-0009-domain-tls.md`
