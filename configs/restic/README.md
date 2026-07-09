# restic

Live env: `/etc/vpn-project/restic.env` (mode 600, gitignored).
Password: `/var/lib/vpn-project/secrets/password_restic`.

```bash
source /etc/vpn-project/restic.env
/opt/vpn-project/scripts/backup.sh pre-change
/opt/vpn-project/scripts/restic-restore-smoke.sh
```
