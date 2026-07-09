# ADR-0003: Monitoring stack (placeholder)

- **Status:** proposed
- **Date:** 2026-07-09

## Context

Need VPS metrics before VPN. UI must not be public (threat model).

## Decision

TBD Stage 2: node_exporter + Prometheus + Grafana; bind localhost; access via SSH tunnel. Native vs Docker chosen at implementation with rationale here.

## Consequences

TBD

## Alternatives considered

| Option | Notes |
|--------|-------|
| Netdata | Heavier UI surface |
| Cloud SaaS agents | Extra trust boundary |
