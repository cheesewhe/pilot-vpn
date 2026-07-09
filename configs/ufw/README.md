# UFW

Do not commit live `ufw status` dumps.

Apply policy from Stage 1 ADR-0002:

1. `IPV6=yes` in `/etc/default/ufw`
2. default deny incoming, allow outgoing
3. allow OpenSSH / 22/tcp
4. `ufw enable`

See `ufw-stage1.rules.template` for a human-readable expected policy.
