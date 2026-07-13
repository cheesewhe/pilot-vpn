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

if ip route | grep -q '10.66.0.0/24'; then
  pass "VPN IPv4 subnet route present"
else
  fail "missing 10.66.0.0/24 route"
fi

if [[ "$(sysctl -n net.ipv4.ip_forward)" == "1" ]]; then
  pass "ip_forward enabled"
else
  fail "ip_forward disabled"
fi

summary
