# Stage 7.5 checklist — Secrets management

## What we did

- Documented policy in `docs/SECRETS.md`
- Created category dirs under `/var/lib/vpn-project/secrets/{wireguard,bot,api,ssh,grafana,restic,git}`
- Compatibility symlinks for existing restic/grafana/git paths

## Verify

```bash
namei -l /var/lib/vpn-project/secrets
ls -la /var/lib/vpn-project/secrets/
test -f /opt/vpn-project/docs/SECRETS.md
```

## Rollback

Docs/dirs only; removing empty reserved dirs is safe.
