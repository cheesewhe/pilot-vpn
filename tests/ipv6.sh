#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== ipv6 =="
if [[ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" == "0" ]]; then
  pass "IPv6 enabled on host"
else
  fail "IPv6 disabled globally"
fi

if ip -6 addr show eth0 | grep -q 'inet6.*global'; then
  pass "eth0 has global IPv6"
else
  fail "eth0 missing global IPv6"
fi

if ping -6 -c 1 -W 3 2001:4860:4860::8888 >/dev/null 2>&1; then
  pass "IPv6 ping to 2001:4860:4860::8888"
else
  skip "IPv6 ping failed (may be filtered upstream)"
fi

summary
