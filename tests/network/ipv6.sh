#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== network-ipv6 =="
if ip -6 addr show wg0 | grep -q 'fd66:66:66::1'; then
  pass "wg0 ULA present"
else
  fail "wg0 ULA missing"
fi
if ip -6 addr show eth0 | grep -q 'inet6.*global'; then
  pass "eth0 global IPv6"
else
  fail "eth0 no global IPv6"
fi
if ping -6 -c 1 -W 3 2001:4860:4860::8888 >/dev/null 2>&1; then
  pass "host IPv6 egress OK"
else
  skip "host IPv6 egress failed"
fi
summary
