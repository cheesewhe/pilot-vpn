#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root
echo "== network-dns =="
for target in 127.0.0.1 10.66.0.1; do
  ANS=$(dig @"$target" example.com A +time=3 +tries=1 +short | head -1 || true)
  if [[ -n "$ANS" ]]; then
    pass "dig @$target example.com -> $ANS"
  else
    fail "dig @$target failed"
  fi
done
# Refuse public recursive (no listen on public IP)
if ss -tuln | awk '$5 ~ /173\.249\.39\.129:53/ {found=1} END{exit !found}'; then
  fail "Unbound on public IP"
else
  pass "Unbound not on public IP"
fi
# Upstream reachability
if dig @1.1.1.1 cloudflare.com +time=2 +tries=1 +short | head -1 | grep -q .; then
  pass "Cloudflare DNS reachable"
else
  fail "Cloudflare DNS unreachable"
fi
if dig @8.8.8.8 google.com +time=2 +tries=1 +short | head -1 | grep -q .; then
  pass "Google DNS reachable"
else
  skip "Google DNS unreachable"
fi
summary
