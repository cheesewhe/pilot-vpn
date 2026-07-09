# ADR-0005: Core DNS service (placeholder)

- **Status:** proposed
- **Date:** 2026-07-09

## Context

DNS must be a core service shared by any VPN backend (cache, IPv6 policy, upstream control).

## Decision

TBD Stage 4: Unbound or CoreDNS on localhost / VPN subnet only.

## Consequences

TBD

## Alternatives considered

| Option | Notes |
|--------|-------|
| Provider DNS only | No control; leak/policy hard |
| DNS inside VPN process only | Couples to one backend |
