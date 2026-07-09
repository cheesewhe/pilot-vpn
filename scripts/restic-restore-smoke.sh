#!/usr/bin/env bash
# Smoke-restore one file from latest restic snapshot into a temp dir
set -euo pipefail

# shellcheck disable=SC1091
source /etc/vpn-project/restic.env

TARGET="${1:-/etc/vpn-project/monitoring/VERSIONS}"
TMP="$(mktemp -d /tmp/restic-restore-XXXXXX)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

echo "== smoke restore: $TARGET =="
restic restore latest --target "$TMP" --include "$TARGET"

RESTORED="$TMP$TARGET"
if [[ ! -f "$RESTORED" ]]; then
  echo "restore missing: $RESTORED" >&2
  find "$TMP" -type f | head -50 >&2 || true
  exit 1
fi

if [[ -f "$TARGET" ]]; then
  if cmp -s "$TARGET" "$RESTORED"; then
    echo "SMOKE_RESTORE_OK (matches live $TARGET)"
  else
    echo "SMOKE_RESTORE_OK (file restored; differs from live — inspect)"
    diff -u "$TARGET" "$RESTORED" || true
  fi
else
  echo "SMOKE_RESTORE_OK (restored; live path absent)"
fi
wc -c "$RESTORED"
