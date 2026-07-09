# Node reputation & resilience (Stage 3.5)

**Captured:** 2026-07-09  
**Host:** vmi3413547 / 173.249.39.129 / 2a02:c207:2341:3547::1

## Reverse DNS (PTR)

| Address | PTR |
|---------|-----|
| 173.249.39.129 | `vmi3413547.contaboserver.net` |
| 2a02:c207:2341:3547::1 | `vmi3413547.contaboserver.net` |

Contabo default PTR is present. Custom PTR only needed if we adopt a personal domain later (Contabo panel / support).

## Forward DNS

| Resolver | A | AAAA |
|----------|---|------|
| 8.8.8.8 | 173.249.39.129 | 2a02:c207:2341:3547::1 |
| 1.1.1.1 | *(empty at check time)* | 2a02:c207:2341:3547::1 |
| 9.9.9.9 | *(empty at check time)* | 2a02:c207:2341:3547::1 |
| local `/etc/hosts` | 127.0.1.1 (cloud-image default) | — |

**Note:** Provider hostname forward-A is inconsistent across public resolvers. Acceptable for SSH-by-IP and VPN-by-IP. If we need a stable name, register our own domain (see ADR-0009).

## IP ownership

- RIPE: Contabo GmbH, DE
- Route: `173.249.38.0/23`, origin **AS51167** (CONTABO)
- Datacenter IP — not residential. Reputation risk is inherent; mitigate with clean ports, no open relays, monitoring.

## DNSBL / blocklists (IPv4)

Queried reverse-octet lookups on 2026-07-09:

| List | Result |
|------|--------|
| zen.spamhaus.org | CLEAN (not listed) |
| bl.spamcop.net | CLEAN |
| dnsbl.sorbs.net | CLEAN |
| b.barracudacentral.org | CLEAN |
| cbl.abuseat.org | CLEAN |

Manual browser checks (Cloudflare-challenged from VPS curl):

- https://www.abuseipdb.com/check/173.249.39.129
- https://talosintelligence.com/reputation_center/lookup?search=173.249.39.129

Re-check these from a browser periodically and after any abuse complaint.

## Public exposure inventory

| Port | Proto | Service | Notes |
|------|-------|---------|-------|
| 22 | tcp | sshd | Only public service; UFW allow; key-only |

No listeners on 80/443. Monitoring bound to localhost only.

## Connectivity baseline

| Target | avg RTT |
|--------|---------|
| 1.1.1.1 | ~4.8 ms |
| 8.8.8.8 | ~4.9 ms |
| 9.9.9.9 | ~5.7 ms |
| cloudflare.com | ~3.9 ms |

Traceroute to 1.1.1.1: Contabo internal → Arelion/Telia → Cloudflare (~9 hops, ~4 ms).

## DNS strategy (input to Stage 4 / ADR-0005)

1. **Host OS resolver:** keep systemd-resolved for now; Contabo DNS OK for package updates.
2. **Project Core DNS (Stage 4):** Unbound/CoreDNS on localhost / future VPN subnet; upstream **1.1.1.1** and **9.9.9.9** (not Contabo) for client tunnel DNS — cache, IPv6 policy, shared by any VPN backend.
3. **Do not** run an open recursive resolver on the public IP.

## Domain & TLS decision

See **ADR-0009**: no custom domain / public TLS certificate in Stage 3.5. Revisit when the chosen VPN protocol needs a hostname (e.g. REALITY/SNI, HTTPS front) or we want branded client endpoints.

## Operational habits

- Before blaming “bad IP”, re-run DNSBL checks and confirm only intended ports are public (`./tests/firewall.sh`).
- Do not run mail/SMTP open services on this node.
- Keep fail2ban + UFW; document any new public port in INVENTORY the same day.
