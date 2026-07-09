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

if systemctl is-active --quiet unbound; then
  pass "unbound active"
else
  fail "unbound not active"
fi

if ss -tuln | grep -qE '127\.0\.0\.1:53'; then
  pass "unbound/local :53 on 127.0.0.1"
else
  fail "no 127.0.0.1:53 listener"
fi

if ss -tuln | grep -qE '0\.0\.0\.0:53|\[::\]:53'; then
  fail "public :53 bind detected"
else
  pass "no public :53 bind"
fi

ANS="$(dig @127.0.0.1 example.com A +time=3 +tries=1 +short | head -1 || true)"
if [[ -n "$ANS" ]]; then
  pass "dig @127.0.0.1 example.com -> $ANS"
else
  fail "dig @127.0.0.1 example.com failed"
fi

summary
