# Stage 1 checklist — Hardening

## What we did

1. Confirmed kernel `6.8.0-134-generic` and SSH key login
2. Created 4 GiB `/swapfile` + fstab
3. Enabled UFW (IPv6 on, deny in, allow 22/tcp)
4. SSH drop-in: password off, root key-only (`00-vpn-project-hardening.conf`)
5. Installed fail2ban jail `sshd`
6. Masked ModemManager
7. Updated ADR-0002, ADR-0008, inventory, network, changelog

## How to verify

```bash
uname -r   # 6.8.0-134-generic
swapon --show
ufw status verbose
sshd -T | grep -Ei 'passwordauthentication|permitrootlogin'
fail2ban-client status sshd
ssh -o BatchMode=yes -i /root/.ssh/id_ed25519 root@127.0.0.1 true
EXPECT_UFW_ACTIVE=1 /opt/vpn-project/tests/all.sh
```

## Expected result

- Swap 4G active
- UFW active; only 22/tcp allowed in
- PasswordAuthentication no; PermitRootLogin without-password
- fail2ban sshd jail running
- all.sh exit 0

## How to roll back

```bash
# SSH: remove drop-in and reload
rm -f /etc/ssh/sshd_config.d/00-vpn-project-hardening.conf
sshd -t && systemctl reload ssh

# UFW
ufw disable

# Swap
swapoff /swapfile
# remove /swapfile line from /etc/fstab; rm /swapfile

# fail2ban
systemctl disable --now fail2ban

# ModemManager
systemctl unmask ModemManager.service
```

Backups: `/opt/vpn-project/backups/manifests/`
