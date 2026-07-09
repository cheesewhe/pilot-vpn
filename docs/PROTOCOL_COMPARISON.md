# Protocol comparison (Stage 5)

**Date:** 2026-07-09  
**Inputs:** `THREAT_MODEL.md`, `REPUTATION.md`, Contabo DC IP (AS51167), personal Mac/mobile clients, Management API roadmap, prior VLESS+REALITY experience (worked, then IP became unusable for the task).

## Candidates

| Protocol | Transport | Maturity | Notes |
|----------|-----------|----------|-------|
| WireGuard | UDP | Excellent | Kernel crypto, tiny surface |
| Xray VLESS + REALITY | TCP (TLS-like) | High in community | Camouflage as HTTPS to real site |
| Hysteria2 | UDP/QUIC | Growing | Aggressive loss resistance |
| TUIC | UDP/QUIC | Growing | QUIC-based |
| OpenVPN | UDP/TCP | Excellent | Heavy, easy to fingerprint |

## Scoring (1–5, higher better)

Weights reflect project goals: long-lived personal infra, ops quality, mobile clients, optional “looks like normal traffic”, **not** “bypass any DPI at any cost”.

| Criterion (weight) | WireGuard | VLESS+REALITY | Hysteria2 | TUIC | OpenVPN |
|--------------------|-----------|---------------|-----------|------|---------|
| Speed / latency (5) | 5 | 4 | 5 | 4 | 3 |
| Stability on Contabo DC IP (5) | 4 | 3 | 3 | 3 | 4 |
| Security / attack surface (5) | 5 | 3 | 3 | 3 | 4 |
| Detectability / HTTPS-likeness (4) | 2 | 5 | 3 | 3 | 1 |
| Client UX macOS/iOS/Android (5) | 5 | 3 | 3 | 3 | 4 |
| Ops / updates / debug (5) | 5 | 3 | 3 | 3 | 4 |
| User-mgmt → API/bot fit (4) | 5 | 4 | 3 | 3 | 2 |
| Coexist with 2nd transport (3) | 5 | 4 | 4 | 4 | 4 |
| **Weighted total** | **172** | **145** | **135** | **129** | **133** |

Weighted total = Σ(score × weight). Max possible = 180.

## Narrative

### WireGuard
Best ops and security story. Native apps on Apple/Android. Keys map cleanly to Management API. Does **not** look like HTTPS — UDP WG is identifiable. Previous Contabo failure was not “fixed” by REALITY either (DC IP / reputation / destination filtering). For a personal encrypted pipe with infrastructure discipline, WG is the strongest primary.

### Xray VLESS + REALITY
Best camouflage. Higher complexity, third-party clients, JSON/UUID lifecycle, larger blast radius if misconfigured. Useful as **optional secondary** when a network blocks WG UDP — not as the foundation of this infra project (monitoring/API/DNS already protocol-agnostic).

### Hysteria2 / TUIC
Strong on lossy links; younger ecosystem; still “VPN-like” UDP/QUIC fingerprints. Good future experiment, weaker than WG for day-1 primary.

### OpenVPN
Reliable but slow/heavy fingerprint; PKI burden for API-driven users. Rejected as primary.

## Decision summary

See **ADR-0007**: **WireGuard primary**; keep Xray/Hysteria placeholders for a possible secondary transport without redesigning infrastructure.
