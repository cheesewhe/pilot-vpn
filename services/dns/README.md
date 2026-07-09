# Core DNS (Unbound)

Live config: `/etc/unbound/unbound.conf.d/vpn-project.conf`  
Template: `configs/dns/unbound-vpn-project.conf.template`

```bash
dig @127.0.0.1 example.com
systemctl status unbound
```

Host OS DNS remains systemd-resolved. Do not open port 53 in UFW.
VPN clients will use this resolver after Stage 6 (via tunnel address).
