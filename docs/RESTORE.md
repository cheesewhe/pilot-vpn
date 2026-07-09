# RESTORE

**Status:** draft (Stage 0). Full procedure after Stage 3 (restic) and Stage 6 (VPN).

## What this project needs to rebuild a node

1. This git repo (`/opt/vpn-project`) — docs, scripts, ADRs, configs templates
2. Encrypted restic repository (Stage 3+) — secrets + `/var/lib/vpn-project` + selected `/etc`
3. Operator SSH public keys
4. Contabo account (recreate VPS if IP/host lost)
5. PROTOCOL ADR + client re-issue process

## Stage 0 recovery (docs only)

If only `/opt/vpn-project` is lost but OS is intact: re-clone/copy git tree. No host services depend on it yet.

## Future full restore (outline)

1. Provision Ubuntu 24.04 on Contabo
2. Install SSH keys; verify serial console
3. Restore `/opt/vpn-project` from git
4. Restore `/var/lib/vpn-project` and `/etc/vpn-project` from restic
5. Reinstall packages per INVENTORY + ADRs
6. Enable units; run `./tests/all.sh`
7. Re-issue clients if keys rotated

## Gaps to close later

- [ ] restic repo location + password storage procedure
- [ ] Ordered service bring-up script
- [ ] Offsite copy of restic repo
