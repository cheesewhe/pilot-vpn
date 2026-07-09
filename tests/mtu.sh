#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== mtu =="
MTU="$(ip -o link show eth0 | awk '{for(i=1;i<=NF;i++) if($i=="mtu"){print $(i+1); exit}}')"
if [[ -n "${MTU:-}" && "$MTU" -ge 1280 ]]; then
  pass "eth0 mtu=$MTU"
else
  fail "unexpected eth0 mtu='${MTU:-}'"
fi
skip "path MTU / large-ping over VPN (Stage 6)"
summary
