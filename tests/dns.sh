#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== dns =="
if getent hosts example.com >/dev/null 2>&1 || host example.com >/dev/null 2>&1; then
  pass "host resolver can resolve example.com"
else
  fail "host resolver failed for example.com"
fi

if systemctl is-active --quiet systemd-resolved; then
  pass "systemd-resolved active"
else
  skip "systemd-resolved not active"
fi

if [[ -d /etc/vpn-project ]] && systemctl list-unit-files 2>/dev/null | grep -qE 'unbound|coredns'; then
  skip "project Core DNS unit check (deploy Stage 4)"
else
  skip "project Core DNS not deployed yet"
fi

summary
