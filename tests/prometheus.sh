#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== prometheus =="

for svc in node_exporter prometheus grafana; do
  if systemctl is-active --quiet "$svc"; then
    pass "$svc active"
  else
    fail "$svc not active"
  fi
done

for port in 9100 9090 3000; do
  if ss -tln | grep -qE "127\.0\.0\.1:${port}\b"; then
    pass "listening 127.0.0.1:${port}"
  else
    fail "not listening 127.0.0.1:${port}"
  fi
  if ss -tln | grep -qE "0\.0\.0\.0:${port}\b|:::${port}\b"; then
    fail "public bind on :${port}"
  else
    pass "no public bind :${port}"
  fi
done

METRICS="$(curl -fsS http://127.0.0.1:9100/metrics)"
if echo "$METRICS" | grep -q node_cpu_seconds_total; then
  pass "node_exporter metrics"
else
  fail "node_exporter metrics missing"
fi

HEALTH="$(curl -fsS 'http://127.0.0.1:9090/api/v1/targets' | python3 -c 'import sys,json; d=json.load(sys.stdin); print(",".join(sorted(t["health"] for t in d["data"]["activeTargets"])))')"
if [[ "$HEALTH" == "up,up" ]]; then
  pass "prometheus targets up"
else
  fail "prometheus targets health=$HEALTH"
fi

CODE="$(curl -fsS -o /dev/null -w '%{http_code}' http://127.0.0.1:3000/login || true)"
if [[ "$CODE" == "200" ]]; then
  pass "grafana login page HTTP 200"
else
  fail "grafana login HTTP $CODE"
fi

summary
