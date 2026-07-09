# Stage 0 checklist — Baseline

## What we did

- Audited clean VPS
- Created FHS project layout
- Wrote core docs + ADR skeleton
- Added tests/scripts placeholders
- Initialized git

## How to verify

```bash
test -f /opt/vpn-project/docs/SERVER_BASELINE.md
test -d /var/lib/vpn-project/secrets && stat -c '%a' /var/lib/vpn-project/secrets | grep -q 700
git -C /opt/vpn-project rev-parse --is-inside-work-tree
/opt/vpn-project/tests/all.sh
```

## Expected result

- Docs present; secrets dir mode 700
- Git repo with initial commit
- `all.sh` exits 0 with VPN-related tests skipped

## How to roll back

Remove project dirs if abandoning (no OS service changes were made):

```bash
# ONLY if intentionally abandoning Stage 0 artifacts
# rm -rf /opt/vpn-project /etc/vpn-project /var/lib/vpn-project /var/log/vpn-project
```
