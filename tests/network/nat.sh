#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== nat =="
if [[ "$(sysctl -n net.ipv4.ip_forward)" == "1" ]]; then
  pass "ipv4 forward=1"
else
  fail "ipv4 forward off"
fi
if [[ "$(sysctl -n net.ipv6.conf.all.forwarding)" == "1" ]]; then
  pass "ipv6 forward=1"
else
  fail "ipv6 forward off"
fi
if iptables -t nat -S POSTROUTING 2>/dev/null | grep -q '10\.66\.0\.0/24'; then
  pass "iptables MASQUERADE for 10.66.0.0/24"
else
  fail "missing IPv4 MASQUERADE rule"
fi
if ip6tables -t nat -S POSTROUTING 2>/dev/null | grep -q 'fd66:66:66::/64'; then
  pass "ip6tables MASQUERADE for fd66:66:66::/64"
else
  fail "missing IPv6 MASQUERADE rule"
fi
if ufw status | grep -q '51820/udp'; then
  pass "UFW allows WG"
else
  fail "UFW missing WG"
fi
# Default forward policy
if grep -q 'DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw; then
  pass "UFW forward policy ACCEPT"
else
  fail "UFW forward policy not ACCEPT"
fi
summary
