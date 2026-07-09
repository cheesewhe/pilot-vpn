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

# Capture full sshd -T first — avoid pipefail+grep -q SIGPIPE false negatives
SSHD_T="$(sshd -T 2>/dev/null)" || SSHD_T=""
if [[ -z "$SSHD_T" ]]; then
  fail "could not query sshd -T"
elif echo "$SSHD_T" | grep -qi '^passwordauthentication no'; then
  pass "sshd effective PasswordAuthentication no"
elif echo "$SSHD_T" | grep -qi '^passwordauthentication yes'; then
  fail "sshd PasswordAuthentication yes (Stage 1 requires no)"
else
  fail "passwordauthentication directive missing from sshd -T"
fi

if echo "$SSHD_T" | grep -qiE '^permitrootlogin (without-password|prohibit-password)'; then
  pass "PermitRootLogin key-only"
else
  fail "PermitRootLogin not key-only"
fi

if systemctl is-active --quiet fail2ban && fail2ban-client status sshd >/dev/null 2>&1; then
  pass "fail2ban sshd jail active"
else
  fail "fail2ban sshd jail missing"
fi

summary
