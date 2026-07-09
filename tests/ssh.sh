#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/tests/_lib.sh"
require_root

echo "== ssh =="
if ss -tlnp | grep -qE ':22\b'; then
  pass "sshd listening on :22"
else
  fail "sshd not listening on :22"
fi

if [[ -f /root/.ssh/authorized_keys ]] && grep -q 'ssh-ed25519' /root/.ssh/authorized_keys; then
  pass "ED25519 authorized_keys present"
else
  fail "missing ED25519 authorized_keys"
fi

# Effective password auth: warn until Stage 1 hardens it (do not fail Stage 0 gate)
if sshd -T 2>/dev/null | grep -qi '^passwordauthentication no'; then
  pass "sshd effective PasswordAuthentication no"
elif sshd -T 2>/dev/null | grep -qi '^passwordauthentication yes'; then
  skip "sshd PasswordAuthentication yes — harden in Stage 1"
else
  skip "could not query sshd -T"
fi

summary
