# Stage 5 checklist — Protocol decision

## What we did

- Wrote `PROTOCOL_COMPARISON.md`
- Accepted ADR-0007: WireGuard primary; secondary deferred

## How to verify

```bash
grep -A2 'Status' /opt/vpn-project/docs/decisions/ADR-0007-vpn-protocol.md
test -f /opt/vpn-project/docs/PROTOCOL_COMPARISON.md
# No VPN package installed yet:
dpkg -l wireguard 2>/dev/null | grep -q ^ii && echo 'WG installed early?' || echo 'WG not installed (expected)'
```

## Expected result

- ADR-0007 status accepted
- No WireGuard/Xray service running yet (Stage 6)

## How to roll back

Amend ADR-0007 to `superseded` with a new ADR if the primary protocol choice changes before Stage 6 install.
