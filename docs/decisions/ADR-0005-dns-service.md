# ADR-0005: Core DNS — Unbound (localhost)

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

DNS must be a core service shared by any future VPN backend: cache, upstream control, IPv6 answers, no coupling to one VPN process. Stage 3.5 required non-Contabo upstreams for tunnel clients and forbade a public open resolver.

## Decision

Deploy **Unbound 1.19.2** as project Core DNS:

| Item | Value |
|------|-------|
| Bind | `127.0.0.1:53` and `[::1]:53` only |
| Access | localhost allow; all else refuse |
| Mode | Forwarding to `1.1.1.1`, `1.0.0.1`, `9.9.9.9`, `149.112.112.112` |
| Host OS DNS | **unchanged** — systemd-resolved + Contabo for the VPS itself |
| resolvconf hook | **masked** (`unbound-resolvconf.service`) so Unbound does not steal `/etc/resolv.conf` |
| Config | `/etc/unbound/unbound.conf.d/vpn-project.conf` (+ copy under `/etc/vpn-project/dns/`) |

Stage 6 will add `access-control` for the VPN subnet (still no public bind).

## Consequences

- VPN clients will point at Unbound (via tunnel IP later), not Contabo DNS
- Two resolvers on loopback (resolved on 127.0.0.53/54, Unbound on 127.0.0.1) — intentional split
- Operators must not open UDP/TCP 53 in UFW

## Alternatives considered

| Option | Why not |
|--------|---------|
| CoreDNS | Fine; Unbound is lighter for recursive/forward cache on Ubuntu |
| Replace systemd-resolved entirely | Higher risk to host package/DNS ops |
| DNS inside VPN process only | Couples to one backend |
| Public recursive Unbound | Threat model violation |

## References

- `docs/REPUTATION.md`
- `configs/dns/unbound-vpn-project.conf.template`
