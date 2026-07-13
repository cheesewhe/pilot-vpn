#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== vpn =="

if systemctl is-active --quiet wg-quick@wg0; then
  pass "wg-quick@wg0 active"
else
  fail "wg-quick@wg0 not active"
fi

if ip -br link show wg0 >/dev/null 2>&1; then
  pass "wg0 interface present"
else
  fail "wg0 missing"
fi

if wg show wg0 2>/dev/null | grep -q 'listening port: 51820'; then
  pass "WireGuard listen 51820"
else
  fail "WG not listening on 51820"
fi

if ip -4 addr show wg0 | grep -q '10.66.0.1'; then
  pass "wg0 has 10.66.0.1"
else
  fail "wg0 missing 10.66.0.1"
fi

if ip -6 addr show wg0 | grep -q 'fd66:66:66::1'; then
  pass "wg0 has fd66:66:66::1"
else
  fail "wg0 missing ULA IPv6"
fi

if [[ "$(sysctl -n net.ipv4.ip_forward)" == "1" ]]; then
  pass "ipv4 forwarding on"
else
  fail "ipv4 forwarding off"
fi

if dig @10.66.0.1 example.com +time=3 +tries=1 +short | head -1 | grep -q .
then
  pass "Unbound via 10.66.0.1"
else
  fail "DNS via 10.66.0.1 failed"
fi

if ufw status | grep -q '51820/udp'; then
  pass "UFW allows 51820/udp"
else
  fail "UFW missing 51820/udp"
fi

if [[ -f /var/lib/vpn-project/secrets/wireguard/clients/macbook.conf ]]; then
  pass "macbook client conf present"
else
  fail "macbook client conf missing"
fi

PEER_COUNT=$(wg show wg0 peers 2>/dev/null | wc -l | tr -d ' ')
if [[ "$PEER_COUNT" -ge 1 ]]; then
  pass "peers configured ($PEER_COUNT)"
else
  fail "no peers"
fi

summary
