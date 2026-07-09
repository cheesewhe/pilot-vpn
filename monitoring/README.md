# Monitoring access

## SSH tunnel (recommended)

```bash
ssh -L 3000:127.0.0.1:3000 -L 9090:127.0.0.1:9090 root@173.249.39.129
```

- Grafana: http://127.0.0.1:3000 — user `admin`, password in `/var/lib/vpn-project/secrets/password_grafana_admin` on the VPS
- Prometheus: http://127.0.0.1:9090

Do **not** open these ports in UFW.

## Layout

| Path | Role |
|------|------|
| `/etc/vpn-project/monitoring/` | Live config |
| `/var/lib/vpn-project/monitoring/` | TSDB / Grafana DB |
| `/opt/vpn-project/monitoring/templates/` | Git-tracked templates |
| `/opt/grafana` | Grafana binary tree |
