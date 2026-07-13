# Stage 6 checklist — WireGuard production

## What we did

- Installed WireGuard; `wg0` with IPv4 `10.66.0.0/24` + IPv6 ULA `fd66:66:66::/64`
- MTU 1280; UFW 51820/udp; ip_forward; NAT; Unbound ACL on VPN subnet
- First peer `macbook` + `.conf` + QR; add/revoke helper scripts
- Client docs: kill-switch, split-tunnel, leak checks

## How to verify

```bash
wg show
systemctl is-active wg-quick@wg0
dig @10.66.0.1 example.com +short
ss -uln | grep 51820
/opt/vpn-project/tests/vpn.sh
/opt/vpn-project/tests/all.sh
```

From Mac after importing config: browse, DNS leak test, confirm public IP = `173.249.39.129`.

## Expected result

- `wg0` up; peer configured; DNS on `10.66.0.1` works from server
- Public listeners: 22/tcp + 51820/udp only
- Client full-tunnel works

## How to roll back

See `docs/WIREGUARD.md` Rollback section. Snapshot tag: `pre-stage6`.
