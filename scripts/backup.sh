#!/usr/bin/env bash
# Encrypted backup via restic (+ lightweight file manifest pointer)
set -euo pipefail

TAG="${1:-manual}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

if [[ ! -f /etc/vpn-project/restic.env ]]; then
  echo "missing /etc/vpn-project/restic.env — Stage 3 not initialized" >&2
  exit 1
fi
# shellcheck disable=SC1091
source /etc/vpn-project/restic.env

EXCLUDES="/etc/vpn-project/restic-excludes.txt"
if [[ ! -f "$EXCLUDES" ]]; then
  EXCLUDES="/opt/vpn-project/configs/restic/excludes.template"
fi

echo "== restic backup tag=${TAG} stamp=${STAMP} =="

restic backup \
  --tag "$TAG" \
  --tag "stamp:${STAMP}" \
  --exclude-file="$EXCLUDES" \
  /etc/vpn-project \
  /etc/ssh/sshd_config \
  /etc/ssh/sshd_config.d \
  /etc/ufw \
  /etc/default/ufw \
  /etc/fail2ban \
  /etc/sysctl.conf \
  /etc/sysctl.d \
  /etc/fstab \
  /etc/systemd/system/node_exporter.service \
  /etc/systemd/system/prometheus.service \
  /etc/systemd/system/grafana.service \
  /var/lib/vpn-project/secrets \
  /var/lib/vpn-project/data \
  /opt/vpn-project

MANIFEST_DIR="/opt/vpn-project/backups/manifests/${STAMP}"
mkdir -p "$MANIFEST_DIR"
{
  echo "stamp=$STAMP"
  echo "tag=$TAG"
  echo "host=$(hostname -f)"
  echo "kernel=$(uname -r)"
  echo "repo=$RESTIC_REPOSITORY"
  restic snapshots --latest 1
  echo
  ss -tuln
} > "$MANIFEST_DIR/MANIFEST.txt"

echo "OK restic snapshot tag=$TAG stamp=$STAMP"
restic snapshots --latest 5
