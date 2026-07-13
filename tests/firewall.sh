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
    if ufw status | grep -qE '51820/udp'; then
      pass "UFW allows 51820/udp"
    else
      fail "UFW missing 51820/udp (Stage 6)"
    fi
  fi
else
  fail "ufw not installed"
fi

# Public listeners: only 22 and 51820 on real public addresses
# Exclude loopback and VPN subnet addresses (10.66.0.0/24, fd66::)
EXTRA="$(ss -tuln | awk 'NR>1 && $5 !~ /127\./ && $5 !~ /::1/ && $5 !~ /10\.66\.0\./ && $5 !~ /fd66:/ && $5 !~ /:22$/ && $5 !~ /:51820$/ {print}' || true)"
if [[ -z "${EXTRA// }" ]]; then
  pass "no unexpected public listeners (only :22 and :51820)"
else
  echo "$EXTRA"
  fail "unexpected public listeners"
fi

summary
