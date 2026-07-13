# Stage 6.5 checklist — Network validation

## What we did

- Added `./tests/network.sh` (handshake, udp, nat, dns, ipv6, mtu, public-ip)
- Client manual checklist: `docs/checklists/client-network-validation.md`
- Documented user/device data model and secrets policy (prep for 7.5 / 8)

## How to verify

```bash
/opt/vpn-project/tests/network.sh
/opt/vpn-project/tests/all.sh
```

Then connect Mac and complete the client checklist; re-run `network.sh` for handshake.

## Expected result

- Server network suite green (handshake may skip until client connects)
- Documented path for leak/roaming/sleep tests on client

## How to roll back

Remove `tests/network/` if abandoning suite (docs-only otherwise). No service changes required for 6.5 itself.
