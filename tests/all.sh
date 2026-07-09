#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "vpn-project test suite"
echo "======================"

FAIL_TOTAL=0
for t in ssh dns dns-leak ipv6 mtu firewall vpn routing prometheus backup speed; do
  echo
  if ! bash "$ROOT/tests/${t}.sh"; then
    FAIL_TOTAL=$((FAIL_TOTAL + 1))
  fi
done

echo
if [[ "$FAIL_TOTAL" -eq 0 ]]; then
  echo "ALL SUITES OK"
  exit 0
fi
echo "FAILED SUITES: $FAIL_TOTAL"
exit 1
