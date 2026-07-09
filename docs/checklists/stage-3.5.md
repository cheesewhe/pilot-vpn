# Stage 3.5 checklist — Reputation & resilience

## What we did

- Documented PTR, DNSBL (clean), ASN/Contabo ownership, public port inventory
- Baseline latency/traceroute
- DNS strategy notes for Stage 4
- ADR-0009: defer custom domain/TLS

## How to verify

```bash
dig -x 173.249.39.129 +short
dig +short 129.39.249.173.zen.spamhaus.org A   # empty = clean
ss -tuln | awk 'NR==1 || ($5 !~ /127\./ && $5 !~ /::1/)'
test -f /opt/vpn-project/docs/REPUTATION.md
```

## Expected result

- PTR → `vmi3413547.contaboserver.net`
- Major DNSBLs not listing the IPv4
- Only public listener: TCP/22
- ADR-0009 accepted (defer domain)

## How to roll back

Documentation-only stage. Remove or amend `docs/REPUTATION.md` / ADR-0009 if decisions change. No host services were added beyond optional `traceroute` package.
