#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== backup =="

if command -v restic >/dev/null; then
  pass "restic installed ($(restic version | head -1 | awk '{print $2}'))"
else
  fail "restic missing"
fi

if [[ -f /etc/vpn-project/restic.env ]]; then
  pass "restic.env present"
else
  fail "restic.env missing"
fi

# shellcheck disable=SC1091
source /etc/vpn-project/restic.env

if [[ -f "$RESTIC_REPOSITORY/config" ]]; then
  pass "restic repo initialized"
else
  fail "restic repo not initialized"
fi

if [[ -f /var/lib/vpn-project/secrets/password_restic ]]; then
  pass "restic password file present"
else
  fail "restic password file missing"
fi

COUNT="$(restic snapshots --json 2>/dev/null | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))' 2>/dev/null || echo 0)"
if [[ "$COUNT" -ge 1 ]]; then
  pass "restic snapshots count=$COUNT"
else
  fail "no restic snapshots"
fi

if systemctl is-enabled --quiet vpn-project-backup.timer && systemctl is-active --quiet vpn-project-backup.timer; then
  pass "backup timer enabled+active"
else
  fail "backup timer not active"
fi

if [[ -f /etc/systemd/journald.conf.d/vpn-project.conf ]]; then
  pass "journald retention drop-in present"
else
  fail "journald drop-in missing"
fi

if [[ -f /etc/logrotate.d/vpn-project ]]; then
  pass "logrotate vpn-project present"
else
  fail "logrotate missing"
fi

summary
