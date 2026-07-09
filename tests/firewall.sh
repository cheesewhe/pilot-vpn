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
    if [[ "${EXPECT_UFW_ACTIVE:-1}" == "0" ]]; then
      pass "UFW present and inactive (EXPECT_UFW_ACTIVE=0)"
    else
      fail "UFW inactive but expected active (Stage 1+)"
    fi
  else
    pass "UFW status: $STATUS"
    if ! ufw status | grep -qE '22/tcp'; then
      fail "UFW active but 22/tcp not allowed"
    else
      pass "UFW allows 22/tcp"
    fi
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
