# Client network validation (Stage 6.5)

Run **after** importing `macbook.conf` (or another peer) into the official WireGuard app.

Expected exit IPv4 while connected: **`173.249.39.129`**

## Automated on server

```bash
/opt/vpn-project/tests/network.sh
```

Handshake age will be `skip` until a client connects; re-run after connect.

## Manual on Mac / phone

| Check | How | Pass criteria |
|-------|-----|---------------|
| IPv4 exit | https://ifconfig.me or `curl -4 ifconfig.me` | `173.249.39.129` |
| IPv6 exit | https://ipv6.icanhazip.com (if using full dual-stack) | Contabo IPv6 or consistent policy |
| DNS | https://dnsleaktest.com (extended) | Only resolvers consistent with tunnel (not home ISP) |
| DNS via Unbound | `scutil --dns` / `dig example.com` while connected | Resolver `10.66.0.1` or app-injected DNS |
| WebRTC leak | https://browserleaks.com/webrtc | No home WAN IP in candidates (disable WebRTC if needed) |
| MTU | Browse HTTPS sites; optional `ping -D -s 1200 10.66.0.1` | No hang on large pages |
| Speed | fast.com / Cloudflare speed test via tunnel | Usable (document Mbps) |
| Reconnect | Toggle WG off/on | Handshake returns; traffic resumes |
| Wi‑Fi → LTE | Switch network with tunnel up | Recovers within ~30s (`PersistentKeepalive=25`) |
| LTE → Wi‑Fi | Same | Recovers |
| Sleep / wake | Close lid 5–10 min, open | Tunnel healthy or one toggle fixes it |
| Kill-switch | Enable in app; disconnect peer suddenly | No clearnet leak while “connected” state broken |

## Record results

Copy into CHANGELOG or a dated note under `docs/checklists/`:

```text
Date:
Device:
IPv4 exit:
DNS leak:
WebRTC:
Speed down/up:
Roaming notes:
Sleep/wake:
Tester:
```

## Failures → Stage 7

Any NAT/IPv6/MTU/DNS issues found here are fixed in **Stage 7 (Firewall/NAT/IPv6 polishing)** before building `vpnctl`.
