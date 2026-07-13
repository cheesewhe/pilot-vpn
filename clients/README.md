# Client configs

**Private client `.conf` files are NOT stored in git.**

Live issued configs: `/var/lib/vpn-project/secrets/wireguard/clients/`

```bash
# Show QR for a peer (on server):
qrencode -t ansiutf8 < /var/lib/vpn-project/secrets/wireguard/clients/macbook.conf

# Copy to Mac (from your Mac):
scp root@173.249.39.129:/var/lib/vpn-project/secrets/wireguard/clients/macbook.conf ~/Downloads/
```

Import into official WireGuard app (macOS/iOS/Android).
