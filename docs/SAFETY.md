# SAFETY

Rules for changing this host.

## Confirm gate

Before any of the following, the operator (or agent) must explain **what / why / risk / verify / rollback** and wait for explicit confirmation:

- SSH configuration
- Firewall (UFW/nft/iptables)
- sysctl / kernel / network routes
- Removing packages or disabling critical services
- systemd unit changes that affect remote access
- Enabling ip_forward / NAT

## Safe sequence

1. Explain change
2. `git status` clean or commit WIP docs
3. Backup: restic tag `pre-change` (after Stage 3) + copy critical files under `/opt/vpn-project/backups/manifests/`
4. Apply
5. Verify with stage checklist + relevant `./tests/*.sh`
6. Keep old SSH session open until a **new** session succeeds
7. Update `CHANGELOG.md`, `INVENTORY.md`, ADR if decision changed
8. Commit

## Emergency access

- Contabo panel serial/VNC console (`ttyS0` getty active at baseline)
- Do not close the last working SSH session after sshd/UFW changes until reconnect works

## Secrets

- Never commit secrets into `/opt/vpn-project`
- Generate only via `scripts/gen-*.sh`
- Store under `/var/lib/vpn-project/secrets` (700/600)
