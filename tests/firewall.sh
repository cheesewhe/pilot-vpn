#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== firewall =="
if command -v ufw >/dev/null 2>&1; then
  STATUS="$(ufw status 2>/dev/null | head -1 || true)"
  if echo "$STATUS" | grep -qi inactive; then
    # Expected at Stage 0; becomes fail after Stage 1 accepts UFW
    if [[ "${EXPECT_UFW_ACTIVE:-0}" == "1" ]]; then
      fail "UFW inactive but EXPECT_UFW_ACTIVE=1"
    else
      pass "UFW present and inactive (expected pre-Stage 1)"
    fi
  else
    pass "UFW status: $STATUS"
  fi
else
  fail "ufw not installed"
fi

# Public listeners besides SSH should be empty at Stage 0
EXTRA="$(ss -tuln | awk 'NR>1 && $5 !~ /127\./ && $5 !~ /::1/ && $5 !~ /:22$/ {print}' || true)"
if [[ -z "${EXTRA// }" ]]; then
  pass "no unexpected public listeners (besides :22)"
else
  echo "$EXTRA"
  fail "unexpected public listeners"
fi

summary
