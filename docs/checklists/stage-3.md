# Stage 3 checklist — Backups & logging

## What we did

- Installed restic; initialized encrypted local repo
- `backup.sh` + daily timer; smoke restore verified
- journald caps (500M / 14d); logrotate for `/var/log/vpn-project`
- ADR-0004 accepted

## How to verify

```bash
source /etc/vpn-project/restic.env
restic snapshots
/opt/vpn-project/scripts/restic-restore-smoke.sh
systemctl list-timers vpn-project-backup.timer
grep -E 'SystemMaxUse|MaxRetention' /etc/systemd/journald.conf.d/vpn-project.conf
/opt/vpn-project/tests/backup.sh
/opt/vpn-project/tests/all.sh
```

## Expected result

- At least one restic snapshot
- Smoke restore matches live VERSIONS file
- Timer scheduled; journald drop-in present

## How to roll back

```bash
systemctl disable --now vpn-project-backup.timer
rm -f /etc/systemd/system/vpn-project-backup.{service,timer}
systemctl daemon-reload
# Keep or remove repo: rm -rf /var/lib/vpn-project/restic/repo  # DESTRUCTIVE
rm -f /etc/systemd/journald.conf.d/vpn-project.conf
systemctl restart systemd-journald
```

**Never delete `password_restic` if you keep the repo.**
