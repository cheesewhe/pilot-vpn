# RESTORE

**Status:** Stage 3 baseline (local restic). Offsite copy still pending.

## What is required to rebuild

1. Git repo `git@github.com:cheesewhe/pilot-vpn.git` → `/opt/vpn-project`
2. restic password: `/var/lib/vpn-project/secrets/password_restic` (or a printed/offline copy)
3. restic repository data: `/var/lib/vpn-project/restic/repo` (or future offsite clone)
4. Operator SSH public keys
5. Contabo account if the VPS itself is gone

## Everyday backup

```bash
/opt/vpn-project/scripts/backup.sh pre-change
```

Daily timer: `vpn-project-backup.timer` (~03:30).

## Smoke restore

```bash
/opt/vpn-project/scripts/restic-restore-smoke.sh
# or specific path:
/opt/vpn-project/scripts/restic-restore-smoke.sh /etc/vpn-project/monitoring/VERSIONS
```

## Partial restore example

```bash
source /etc/vpn-project/restic.env
TMP=$(mktemp -d)
restic restore latest --target "$TMP" --include /etc/ssh/sshd_config.d
# inspect then copy carefully
```

## Full node rebuild (outline)

1. Provision Ubuntu 24.04; install SSH keys; verify serial console
2. `git clone` project; install packages per INVENTORY + ADRs
3. Restore `/etc/vpn-project`, `/var/lib/vpn-project/secrets`, units from restic
4. Re-enable services; run `./tests/all.sh`
5. Re-issue clients if keys rotated

## Gaps still open

- [ ] Offsite restic copy (S3/B2/second VPS) — new ADR
- [ ] Printed/offline escrow of `password_restic`
- [ ] Ordered `scripts/restore-node.sh` automation
