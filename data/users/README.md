# User data schema (runtime lives in /var/lib/vpn-project/data/users/)

Each user record: `/var/lib/vpn-project/data/users/<id>.json`

```json
{
  "id": "alice",
  "display_name": "Alice",
  "group": "default",
  "status": "active",
  "created_at": "2026-07-09T00:00:00Z",
  "expires_at": null,
  "backends": {
    "primary": { "type": "TBD", "credential_ref": "/var/lib/vpn-project/secrets/..." }
  },
  "notes": ""
}
```

`status`: active | blocked | revoked

Do not store private keys inside the JSON; reference files under `secrets/`.
