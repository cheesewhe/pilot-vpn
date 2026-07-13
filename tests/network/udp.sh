#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== udp =="
if ss -ulnp | grep -q ':51820'; then
  pass "WG UDP socket present"
else
  fail "no WG UDP socket"
fi
# Confirm not firewalled from local perspective
if ufw status verbose | grep -A2 '51820/udp' | grep -qi ALLOW; then
  pass "UFW ALLOW 51820/udp"
else
  fail "UFW not allowing 51820"
fi
summary
