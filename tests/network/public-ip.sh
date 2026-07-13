#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== public-ip =="
# From server itself (not through tunnel) — documents expected exit IP for clients
EXPECT=173.249.39.129
GOT=$(curl -4 -fsS --max-time 5 https://ifconfig.me/ip 2>/dev/null || curl -4 -fsS --max-time 5 https://api.ipify.org 2>/dev/null || true)
if [[ "$GOT" == "$EXPECT" ]]; then
  pass "server public IPv4=$GOT"
else
  fail "server public IPv4='$GOT' expected $EXPECT"
fi
# Connectivity smoke
for url in https://1.1.1.1 https://www.cloudflare.com https://www.google.com; do
  CODE=$(curl -4 -fsS -o /dev/null -w '%{http_code}' --max-time 8 "$url" || echo 000)
  if [[ "$CODE" =~ ^(200|301|302|403)$ ]]; then
    pass "reachable $url (HTTP $CODE)"
  else
    fail "unreachable $url (HTTP $CODE)"
  fi
done
summary
