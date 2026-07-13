#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "vpn-project network validation"
echo "=============================="
FAIL_TOTAL=0
for t in handshake udp nat dns ipv6 mtu public-ip; do
  echo
  if ! bash "$ROOT/tests/network/${t}.sh"; then
    FAIL_TOTAL=$((FAIL_TOTAL + 1))
  fi
done
echo
if [[ "$FAIL_TOTAL" -eq 0 ]]; then
  echo "NETWORK SUITE OK (client-side leak/roaming tests: see docs/checklists/client-network-validation.md)"
  exit 0
fi
echo "NETWORK FAILED SUITES: $FAIL_TOTAL"
exit 1
