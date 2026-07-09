#!/usr/bin/env bash
# Shared helpers for vpn-project tests
set -euo pipefail

PASS=0
FAIL=0
SKIP=0

pass() { echo "✔ $*"; PASS=$((PASS + 1)); }
fail() { echo "✘ $*"; FAIL=$((FAIL + 1)); }
skip() { echo "↷ $* (skip)"; SKIP=$((SKIP + 1)); }

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Tests expect root on this host" >&2
    exit 2
  fi
}

summary() {
  echo
  echo "--- summary: pass=$PASS fail=$FAIL skip=$SKIP ---"
  [[ "$FAIL" -eq 0 ]]
}
