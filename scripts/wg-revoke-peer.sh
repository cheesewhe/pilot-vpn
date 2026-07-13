#!/usr/bin/env bash
# Revoke WireGuard peer by name
set -euo pipefail
NAME="${1:-}"
[[ -n "$NAME" ]] || { echo "Usage: $0 <peer-name>" >&2; exit 1; }

PUB_FILE=/var/lib/vpn-project/secrets/wireguard/peers/${NAME}_public.key
[[ -f "$PUB_FILE" ]] || { echo "unknown peer: $NAME" >&2; exit 1; }
PUB=$(cat "$PUB_FILE")

wg set wg0 peer "$PUB" remove || true

# Remove peer block from wg0.conf (between "# peer: name" and next "# peer:" or EOF)
python3 - "$NAME" << 'PY'
from pathlib import Path
import re, sys
name = sys.argv[1]
p = Path('/etc/wireguard/wg0.conf')
text = p.read_text()
pat = re.compile(rf"\n# peer: {re.escape(name)}\n\[Peer\]\n.*?(?=\n# peer: |\Z)", re.S)
new, n = pat.subn("\n", text, count=1)
if n:
    p.write_text(new)
    print(f"removed {name} from wg0.conf")
else:
    print("warning: peer block not found in wg0.conf", file=sys.stderr)
PY

META=/var/lib/vpn-project/data/users/${NAME}.json
if [[ -f "$META" ]]; then
  python3 - "$META" << 'PY'
import json,sys
from pathlib import Path
p=Path(sys.argv[1])
d=json.loads(p.read_text())
d['status']='revoked'
p.write_text(json.dumps(d, indent=2)+'\n')
PY
fi

echo "revoked $NAME (keys retained under secrets for audit; delete manually if desired)"
