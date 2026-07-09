# CHANGELOG

All notable stage completions and host changes.

## 2026-07-09 — Stage 2 complete

### What

- Native node_exporter 1.11.1, Prometheus 3.13.0, Grafana 13.1.0 on 127.0.0.1 only
- systemd units + provisioning dashboard; ADR-0003 accepted
- Grafana admin password in `/var/lib/vpn-project/secrets/password_grafana_admin`

### Why

Observe the VPS before introducing VPN services; keep metrics UI off the public internet.

### Verify

- `/opt/vpn-project/tests/prometheus.sh`
- SSH tunnel to :3000 / :9090

### Rollback

See `docs/checklists/stage-2.md`.

## 2026-07-09 — Stage 1.5 complete

### What

- Tightened `.gitignore`; live configs → `*.template` only in git
- Generated deploy key at `/var/lib/vpn-project/secrets/git_deploy_ed25519` (not in git)
- Linked `origin` → `git@github.com:cheesewhe/pilot-vpn.git` and pushed `main`

### Why

Private remote backup of infrastructure-as-code without leaking secrets.

### Verify

- `git status` clean; branch tracks `origin/main`
- `git ls-files` contains no secrets / live conf dumps

### Rollback

- `git remote remove origin` (local history retained)

## 2026-07-09 — Stage 1 complete

### What

- Confirmed boot on kernel 6.8.0-134-generic; SSH key auth OK
- Added 4 GiB swapfile
- Enabled UFW (IPv6, deny in, allow 22/tcp)
- SSH hardening drop-in: PasswordAuthentication no, root key-only
- fail2ban sshd jail; ModemManager masked
- ADR-0002 accepted; ADR-0008 SSH hardening accepted

### Why

Reduce public attack surface and close password SSH before adding services.

### Files

- `/etc/ssh/sshd_config.d/00-vpn-project-hardening.conf`
- `/etc/fail2ban/jail.d/vpn-project-sshd.conf`
- `/etc/default/ufw`, UFW rules
- `/swapfile`, `/etc/fstab`
- `/opt/vpn-project/docs/**`, `configs/ssh|fail2ban|ufw`

### Verify

- `EXPECT_UFW_ACTIVE=1 /opt/vpn-project/tests/all.sh`
- `sshd -T | grep passwordauthentication` → no
- `fail2ban-client status sshd`

### Rollback

See `docs/checklists/stage-1.md`.

## 2026-07-09 — Stage 0 complete

### What

- Created project layout under `/opt/vpn-project`, `/etc/vpn-project`, `/var/lib/vpn-project`, `/var/log/vpn-project`
- Wrote baseline docs: SERVER_BASELINE, INVENTORY, THREAT_MODEL, NETWORK, SAFETY, UPDATE_POLICY, LOGGING, RESTORE (draft)
- Added ADR template + ADR-0006 secrets layout
- Added test skeleton and helper scripts
- Initialized git repository

### Why

Establish infrastructure-as-a-project before hardening or VPN.

### Files

- `/opt/vpn-project/**` (new)
- `/etc/vpn-project/README.md`
- `/var/lib/vpn-project/**`

### Verify

- `test -d /opt/vpn-project/docs`
- `git -C /opt/vpn-project status`
- `./tests/all.sh` (Stage 0 subset; VPN tests skip)

### Rollback

- Remove `/opt/vpn-project`, `/etc/vpn-project`, `/var/lib/vpn-project`, `/var/log/vpn-project` if abandoning project (does not affect OS services; none changed)
