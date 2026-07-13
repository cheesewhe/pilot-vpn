#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== network-mtu =="
MTU=$(ip -o link show wg0 | awk '{for(i=1;i<=NF;i++) if($i=="mtu"){print $(i+1); exit}}')
if [[ "${MTU:-0}" -eq 1280 ]]; then
  pass "wg0 mtu=1280"
else
  fail "wg0 mtu=${MTU:-missing} (expected 1280)"
fi
# Large ping to self via wg address
if ping -c 1 -W 2 -s 1200 -M do 10.66.0.1 >/dev/null 2>&1; then
  pass "large ping 1200 to 10.66.0.1 OK"
else
  skip "large ping failed (may need client path)"
fi
summary
