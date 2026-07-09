# Stage 4 checklist — Core DNS

## What we did

- Installed Unbound; localhost-only bind; forward to Cloudflare/Quad9
- Masked unbound-resolvconf; host keeps systemd-resolved
- ADR-0005 accepted

## How to verify

```bash
systemctl is-active unbound
ss -tulnp | grep unbound
dig @127.0.0.1 example.com +short
# must fail / refuse from perspective of public — no 0.0.0.0:53
ss -tuln | grep -E '0\.0\.0\.0:53|\[::\]:53' || echo 'no public :53'
/opt/vpn-project/tests/dns.sh
```

## Expected result

- Unbound active on 127.0.0.1:53 / ::1:53
- Resolves example.com
- Host `getent hosts` still works via systemd-resolved
- No UFW rule for 53

## How to roll back

```bash
systemctl disable --now unbound
rm -f /etc/unbound/unbound.conf.d/vpn-project.conf
systemctl unmask unbound-resolvconf.service  # only if intentionally restoring package default
```
