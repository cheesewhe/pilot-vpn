# Stage 2 checklist — Monitoring VPS

## What we did

- Installed node_exporter 1.11.1, Prometheus 3.13.0, Grafana 13.1.0 (native)
- Bound all to 127.0.0.1 only
- Provisioned Prometheus datasource + VPS Node Overview dashboard
- Accepted ADR-0003

## How to verify

```bash
systemctl is-active node_exporter prometheus grafana
ss -tlnp | grep -E '127\.0\.0\.1:(9100|9090|3000)'
/opt/vpn-project/tests/prometheus.sh
/opt/vpn-project/tests/all.sh
```

SSH tunnel from Mac:

```bash
ssh -L 3000:127.0.0.1:3000 -L 9090:127.0.0.1:9090 root@173.249.39.129
# open http://127.0.0.1:3000  (admin / password from secrets file on server)
```

Password file on server: `/var/lib/vpn-project/secrets/password_grafana_admin`

## Expected result

- All three units active
- No public binds on 9100/9090/3000
- Prometheus targets `node` and `prometheus` = up
- Grafana login HTTP 200 via localhost/tunnel

## How to roll back

```bash
systemctl disable --now grafana prometheus node_exporter
rm -f /etc/systemd/system/{grafana,prometheus,node_exporter}.service
systemctl daemon-reload
# optional: rm -rf /opt/grafana /var/lib/vpn-project/monitoring
```
