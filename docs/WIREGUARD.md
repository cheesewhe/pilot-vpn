# WireGuard (Stage 6)

## Server

| Item | Value |
|------|-------|
| Interface | `wg0` |
| Port | UDP **51820** (UFW allowed) |
| IPv4 | `10.66.0.0/24` (server `.1`) |
| IPv6 ULA | `fd66:66:66::/64` (server `::1`) |
| MTU | **1280** (safe for mobile / dual-stack) |
| DNS | `10.66.0.1` (Unbound) |
| Endpoint | `173.249.39.129:51820` |
| Unit | `wg-quick@wg0` |

Secrets: `/var/lib/vpn-project/secrets/wireguard/`  
Live config: `/etc/wireguard/wg0.conf` (mode 600)

## Add / revoke peer

```bash
/opt/vpn-project/scripts/wg-add-peer.sh alice
/opt/vpn-project/scripts/wg-revoke-peer.sh alice
qrencode -t ansiutf8 < /var/lib/vpn-project/secrets/wireguard/clients/alice.conf
```

## First client: macbook

```bash
# On Mac:
scp root@173.249.39.129:/var/lib/vpn-project/secrets/wireguard/clients/macbook.conf ~/Downloads/
# Import into WireGuard.app — full tunnel (0.0.0.0/0, ::/0), DNS 10.66.0.1
```

Or scan QR printed on the server:
`qrencode -t ansiutf8 < /var/lib/vpn-project/secrets/wireguard/clients/macbook.conf`

## Client guidance

### Kill-switch (macOS WireGuard app)
Enable **“Block untunneled traffic (kill-switch)”** / equivalent in the peer settings so traffic does not leak if the tunnel drops.

### Split tunneling
Use `AllowedIPs = 10.66.0.0/24, fd66:66:66::/64` (and any other nets you need) instead of `0.0.0.0/0, ::/0`. See `clients/macbook.split-tunnel.example.conf`.

### DNS / IPv6 / WebRTC leaks
- Client DNS must be `10.66.0.1` only while connected.
- Verify: https://dnsleaktest.com / https://ipleak.net after connect.
- Browser WebRTC can still reveal local candidates — disable WebRTC or use browser hardening if needed.

### MTU
If sites hang but ping works, try client MTU `1280` (default here) or `1380`. Large ping test: `ping -s 1200 -M do 10.66.0.1`.

## Verify on server

```bash
systemctl status wg-quick@wg0
wg show
ufw status | grep 51820
dig @10.66.0.1 example.com +short
/opt/vpn-project/tests/vpn.sh
```

## Rollback

```bash
systemctl disable --now wg-quick@wg0
ufw delete allow 51820/udp
# optionally revert DEFAULT_FORWARD_POLICY and NAT blocks in /etc/ufw/before.rules
sysctl -w net.ipv4.ip_forward=0 net.ipv6.conf.all.forwarding=0
```
