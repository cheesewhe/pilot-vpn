# ADR-0005: Core DNS service (placeholder)

- **Status:** proposed
- **Date:** 2026-07-09

## Context

DNS must be a core service shared by any VPN backend (cache, IPv6 policy, upstream control).

## Decision

TBD Stage 4 implementation choice: **Unbound or CoreDNS**, bind **localhost / future VPN subnet only** (never public recursive).

Constraints from Stage 3.5 (`docs/REPUTATION.md`):

- Upstream for tunnel clients: prefer `1.1.1.1` + `9.9.9.9` (not Contabo DNS)
- Host OS may keep systemd-resolved + Contabo for package updates
- No open resolver on public IP
- Shared by any VPN backend

## Consequences

TBD

## Alternatives considered

| Option | Notes |
|--------|-------|
| Provider DNS only | No control; leak/policy hard |
| DNS inside VPN process only | Couples to one backend |
