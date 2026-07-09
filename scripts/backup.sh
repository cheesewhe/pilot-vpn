#!/usr/bin/env bash
# Stage 0/1 lightweight file backup until restic (Stage 3)
set -euo pipefail

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
DEST="/opt/vpn-project/backups/manifests/${STAMP}"
mkdir -p "$DEST"

echo "Backing up critical paths to $DEST"

copy_if() {
  local src="$1"
  if [[ -e "$src" ]]; then
    mkdir -p "$DEST$(dirname "$src")"
    cp -a "$src" "$DEST$src"
    echo "  + $src"
  fi
}

copy_if /etc/ssh/sshd_config
copy_if /etc/ssh/sshd_config.d
copy_if /etc/netplan
copy_if /etc/ufw
copy_if /etc/sysctl.conf
copy_if /etc/sysctl.d
copy_if /etc/vpn-project

# Manifest
{
  echo "stamp=$STAMP"
  echo "host=$(hostname -f)"
  echo "kernel=$(uname -r)"
  ss -tuln
} > "$DEST/MANIFEST.txt"

# Do not store secrets here; remind operator
echo "NOTE: secrets under /var/lib/vpn-project are NOT copied by this helper (use restic Stage 3)."
echo "OK $DEST"
