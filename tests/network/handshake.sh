#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== handshake =="
if systemctl is-active --quiet wg-quick@wg0 && wg show wg0 >/dev/null; then
  pass "wg0 up"
else
  fail "wg0 down"
fi
if ss -uln | grep -q ':51820'; then
  pass "UDP 51820 listening"
else
  fail "UDP 51820 not listening"
fi
# Peers may show handshake only after client connects
HS=$(wg show wg0 latest-handshakes 2>/dev/null | awk '{print $2}' | head -1 || echo 0)
if [[ "${HS:-0}" -gt 0 ]]; then
  AGE=$(( $(date +%s) - HS ))
  if [[ $AGE -lt 180 ]]; then
    pass "recent handshake age=${AGE}s"
  else
    skip "handshake stale age=${AGE}s (connect a client and re-run)"
  fi
else
  skip "no client handshake yet (import macbook.conf and connect)"
fi
summary
