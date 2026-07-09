# ADR-0006: Secrets and state layout (FHS)

- **Status:** accepted
- **Date:** 2026-07-09
- **Deciders:** project owner + operator

## Context

The project must store private keys, tokens, and live user data without mixing them into the git-managed code tree under `/opt`. Mixing secrets into `/opt/vpn-project` risks accidental commits and confuses “code” with “runtime”.

## Decision

Follow Linux FHS split:

| Path | Contents |
|------|----------|
| `/opt/vpn-project` | Code, docs, tests, templates, git |
| `/etc/vpn-project` | Deployed non-secret configuration |
| `/var/lib/vpn-project` | Secrets (`secrets/`), live user data, restic repo metadata |
| `/var/log/vpn-project` | Project log files when not using journald only |

Permissions: `/var/lib/vpn-project` mode `755` (service users must traverse to `monitoring/`); `secrets/` mode `700`; secret files `600`. Git ignores all secret patterns.

Secrets are created only via `scripts/gen-*.sh`.

## Consequences

- Safer git workflow; restores need both git + restic
- Operators must remember two trees (`/opt` + `/var/lib`)
- Service units will reference `/etc` and `/var/lib`, not `/opt/secrets`

## Alternatives considered

| Option | Why not |
|--------|---------|
| `/opt/vpn-project/secrets` + gitignore | Easy to mis-add; violates FHS; still sits next to code |
| HashiCorp Vault / SOPS from day one | Overkill for personal v1; can supersede later via new ADR |
| Home-directory secrets | Unclear for multi-service system users |

## References

- `docs/THREAT_MODEL.md`
- `docs/SAFETY.md`
