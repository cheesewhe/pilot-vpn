# ADR-0004: Backup tool — restic

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Need encrypted, restorable backups of configs and secrets beyond `tar`/`cp` manifests. Offsite copy can come later; local encrypted repo is the Stage 3 baseline.

## Decision

Use **restic 0.16.4** (Ubuntu noble package):

| Item | Value |
|------|-------|
| Repository | `/var/lib/vpn-project/restic/repo` |
| Password file | `/var/lib/vpn-project/secrets/password_restic` |
| Env | `/etc/vpn-project/restic.env` (mode 600, not in git) |
| Wrapper | `/opt/vpn-project/scripts/backup.sh` |
| Smoke restore | `/opt/vpn-project/scripts/restic-restore-smoke.sh` |
| Schedule | `vpn-project-backup.timer` daily ~03:30 |
| Excludes | TSDB/Grafana data, restic repo itself, `.git`, swapfile |

Git continues to track code/docs; restic covers secrets + live `/etc` state.

## Consequences

- Losing `password_restic` = irrecoverable repo
- Local-only until offsite ADR; disk failure still a risk
- Operators must run smoke restore after major changes

## Alternatives considered

| Option | Why not |
|--------|---------|
| borgbackup | Strong; restic simpler CLI for v1 |
| plain tar of `/etc` | No encryption/dedup |
| Only git | Cannot hold secrets |

## References

- `docs/LOGGING.md`, `docs/RESTORE.md`
- `configs/restic/excludes.template`
