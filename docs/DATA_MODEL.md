# Data model — users & devices

Designed so the platform can grow to **dozens of devices** and later **multiple servers** without rewriting peer scripts into a mess.

## Entities

### User

Logical person / account (not a WireGuard peer).

| Field | Example |
|-------|---------|
| `id` | `alice` |
| `display_name` | Alice |
| `group` | `family` / `default` |
| `status` | `active` \| `blocked` \| `revoked` |
| `expires_at` | ISO8601 or null |
| `device_ids` | `["alice-macbook", "alice-iphone"]` |

Runtime: `/var/lib/vpn-project/data/users/<id>.json`

### Device

One WireGuard peer (one keypair, one tunnel IP).

| Field | Example |
|-------|---------|
| `id` | `alice-macbook` |
| `user_id` | `alice` |
| `status` | `active` \| `revoked` |
| `wg.public_key` | … |
| `wg.ipv4` | `10.66.0.3` |
| `wg.ipv6` | `fd66:66:66::3` |
| `config_issued_at` | ISO8601 |
| `config_path` | secrets path (not in git) |
| `server_id` | `contabo-eu-1` (default now) |
| `last_handshake` | filled by stats/exporter later |

Runtime: `/var/lib/vpn-project/data/devices/<id>.json`

### Server (future)

| Field | Example |
|-------|---------|
| `id` | `contabo-eu-1` |
| `endpoint` | `173.249.39.129:51820` |
| `public_key` | … |

Today there is one implied server; `server_id` is stored so multi-node does not require a migration later.

## Relationship

```text
User 1──* Device  *──1 Server
```

`vpnctl add-user` creates the user.  
`vpnctl add-device --user alice --name macbook` allocates IP + keys + conf.

## Migration from Stage 6

Current `macbook` peer is a **device**. Stage 8 CLI will normalize it to:

- user: `owner` (or `default`)
- device: `macbook`
- server_id: `contabo-eu-1`

Schema docs live under `/opt/vpn-project/data/`; live JSON under `/var/lib/vpn-project/data/`.
