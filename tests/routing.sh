#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== routing =="
if ip route | grep -q '^default '; then
  pass "IPv4 default route present"
else
  fail "missing IPv4 default route"
fi
if ip -6 route | grep -q '^default '; then
  pass "IPv6 default route present"
else
  skip "no IPv6 default route"
fi
skip "VPN routing table checks (Stage 6)"
summary
