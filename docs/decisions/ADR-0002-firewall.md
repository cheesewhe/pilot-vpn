# ADR-0002: Firewall (placeholder)

- **Status:** proposed
- **Date:** 2026-07-09

## Context

Host has no active firewall at baseline. Stage 1 will enable UFW.

## Decision

TBD at Stage 1 acceptance: UFW default deny incoming; allow SSH; IPv6 on; VPN ports added only when backend exists.

## Consequences

TBD

## Alternatives considered

| Option | Notes |
|--------|-------|
| nftables raw | More flexible; higher footgun for v1 |
| provider firewall only | Contabo panel rules possible later; host UFW still required |
