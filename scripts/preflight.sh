#!/usr/bin/env bash
# Preflight before dangerous changes
set -euo pipefail

echo "== preflight =="
echo "host: $(hostname -f)"
echo "date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "uptime: $(uptime -p 2>/dev/null || uptime)"

echo "-- disk --"
df -h / | tail -1

echo "-- memory --"
free -h | head -2

echo "-- ssh listeners --"
ss -tlnp | grep -E ':22\b' || echo "WARNING: no :22 listener"

echo "-- reboot required --"
if [[ -f /var/run/reboot-required ]]; then
  echo "YES: /var/run/reboot-required present"
  cat /var/run/reboot-required.pkgs 2>/dev/null || true
else
  echo "no"
fi

echo "-- git --"
if git -C /opt/vpn-project status --porcelain 2>/dev/null | grep -q .; then
  echo "WARNING: dirty git worktree in /opt/vpn-project"
  git -C /opt/vpn-project status --short
else
  echo "git clean or not a repo yet"
fi

echo "-- secrets dir perms --"
stat -c '%a %n' /var/lib/vpn-project/secrets 2>/dev/null || echo "missing secrets dir"

echo "preflight done"
