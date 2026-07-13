# Stage 7 checklist — Firewall / NAT / IPv6 polishing

## What we did

- Removed duplicate MASQUERADE from UFW `before.rules` / `before6.rules`
- Single NAT source of truth: `wg-quick` PostUp/PostDown on `wg0`
- Confirmed forward sysctl, UFW 51820/udp, dual-stack wg addresses
- Re-validated with `./tests/network.sh`

## How to verify

```bash
iptables -t nat -S POSTROUTING | grep 10.66
# expect exactly one MASQUERADE line for 10.66.0.0/24
ip6tables -t nat -S POSTROUTING | grep fd66
/opt/vpn-project/tests/network.sh
```

## Expected result

- One IPv4 and one IPv6 MASQUERADE rule tied to wg-quick lifecycle
- SSH still works; WG still listens on 51820

## Rollback

Re-insert NAT blocks into UFW before.rules from git history if needed; prefer keeping PostUp-only.
