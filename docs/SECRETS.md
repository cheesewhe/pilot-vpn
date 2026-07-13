# Secrets management (Stage 7.5)

## Layout

```text
/var/lib/vpn-project/secrets/          mode 700, root:root
  wireguard/
    server_private.key
    server_public.key
    peers/<device>_{private,public}.key
    peers/<device>.psk
    clients/<device>.conf
    clients/<device>.png
  password_restic
  password_grafana_admin
  git_deploy_ed25519
  git_deploy_ed25519.pub
  # reserved:
  bot/          # Telegram token later
  api/          # API tokens later
  ssh/          # optional host/project keys later
```

Never store these under `/opt/vpn-project` or commit them. Git tracks only templates and docs.

## Permissions

| Path | Mode | Owner |
|------|------|-------|
| `/var/lib/vpn-project` | `755` | root (traverse for services) |
| `secrets/` | `700` | root |
| secret files | `600` | root |
| `data/` | `750` | root |

## Backup

- Included in restic via `/var/lib/vpn-project/secrets` (encrypted).
- Escrow **restic password** and **git deploy key** offline (password manager / printed sealed note).
- Client `.conf` re-issuable; prefer revoke+recreate over emailing old confs.

## Rotation

| Secret | Cadence | Procedure |
|--------|---------|-----------|
| WG peer key | on revoke / compromise | `wg-revoke-peer` + `wg-add-peer` (later `vpnctl`) |
| WG server key | rare / incident | regenerate, rewrite all clients (maintenance window) |
| restic password | annual or incident | `restic key passwd`; update password file + escrow |
| Grafana admin | annual or incident | change in grafana.ini / UI; update secrets file |
| git deploy key | annual or incident | new key → GitHub deploy keys → remove old |
| API / bot tokens | on leak | regenerate; update unit env |

## Ownership rules

1. Generate only via `scripts/gen-keys.sh` or `wg` helpers — no copy-paste into chat/git.
2. `vpnctl` / API read secrets; Telegram bot must **not** read WG private keys (only API).
3. After any secret change: `/opt/vpn-project/scripts/backup.sh pre-secret-rotation`

## ADR

Related: ADR-0006 (FHS secrets layout). This document is the operational policy; open a new ADR if introducing Vault/SOPS.
