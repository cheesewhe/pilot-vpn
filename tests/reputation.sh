#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== reputation =="

IP4=173.249.39.129
PTR="$(dig +short -x "$IP4" | head -1 | sed 's/\.$//')"
if [[ "$PTR" == *contaboserver.net ]]; then
  pass "PTR present ($PTR)"
else
  fail "unexpected PTR='$PTR'"
fi

REV=$(echo "$IP4" | awk -F. '{print $4"."$3"."$2"."$1}')
ZEN="$(dig +short "${REV}.zen.spamhaus.org" A | tr '\n' ' ')"
if [[ -z "${ZEN// }" ]]; then
  pass "Spamhaus ZEN not listed"
else
  # 127.255.255.254 etc can be policy errors
  fail "Spamhaus ZEN response: $ZEN"
fi

EXTRA="$(ss -tuln | awk 'NR>1 && $5 !~ /127\./ && $5 !~ /::1/ && $5 !~ /:22$/ {print}')"
if [[ -z "${EXTRA// }" ]]; then
  pass "no unexpected public listeners"
else
  echo "$EXTRA"
  fail "unexpected public listeners"
fi

if [[ -f /opt/vpn-project/docs/REPUTATION.md ]]; then
  pass "REPUTATION.md present"
else
  fail "REPUTATION.md missing"
fi

summary
