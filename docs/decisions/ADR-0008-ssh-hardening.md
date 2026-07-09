# ADR-0008: SSH hardening

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

Effective `PasswordAuthentication` was **yes** due to conflicting cloud-init drop-ins (`50-cloud-init.conf` yes vs `60-cloudimg-settings.conf` no). OpenSSH uses **first** obtained value in `sshd_config.d` order.

## Decision

Deploy `/etc/ssh/sshd_config.d/00-vpn-project-hardening.conf` (lexically first):

- `PasswordAuthentication no`
- `KbdInteractiveAuthentication no`
- `PubkeyAuthentication yes`
- `PermitRootLogin prohibit-password`
- `AuthenticationMethods publickey`

Safe apply procedure: backup → `sshd -t` → `systemctl reload ssh` → verify **new** key session → only then rely on change.

SSH port remains 22 (no port change in Stage 1). Root remains allowed via key only (no extra sudo user yet).

## Consequences

- Password auth closed
- Root key compromise still = full host (future: dedicated admin user via new ADR)
- cloud-init may rewrite other drop-ins; `00-` prefix keeps our policy winning

## Alternatives considered

| Option | Why not now |
|--------|-------------|
| Disable root + sudo user | Good follow-up; needs extra key/user ops |
| Change SSH port | Security through obscurity; defer |
| AllowUsers | Defer until non-root admin exists |

## References

- `docs/SAFETY.md`
- `/etc/ssh/sshd_config.d/00-vpn-project-hardening.conf`
