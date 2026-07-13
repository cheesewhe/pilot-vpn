#!/usr/bin/env bash
# Add a WireGuard peer and emit client config + QR (Stage 6 helper; Stage 7 → vpnctl)
set -euo pipefail

NAME="${1:-}"
if [[ -z "$NAME" || ! "$NAME" =~ ^[a-z0-9_-]+$ ]]; then
  echo "Usage: $0 <peer-name>" >&2
  exit 1
fi

PEER_DIR=/var/lib/vpn-project/secrets/wireguard/peers
CLIENT_DIR=/var/lib/vpn-project/secrets/wireguard/clients
install -d -m 700 "$PEER_DIR" "$CLIENT_DIR"

PRIV="$PEER_DIR/${NAME}_private.key"
PUB="$PEER_DIR/${NAME}_public.key"
PSK="$PEER_DIR/${NAME}.psk"

if [[ -f "$PRIV" ]]; then
  echo "peer already exists: $NAME" >&2
  exit 1
fi

# Next free IPv4 in 10.66.0.2-254
USED=$(wg show wg0 allowed-ips 2>/dev/null | grep -oE '10\.66\.0\.[0-9]+' || true)
NEXT=2
while echo "$USED" | grep -qx "10.66.0.$NEXT"; do
  NEXT=$((NEXT + 1))
  if [[ $NEXT -gt 254 ]]; then echo "no free IPs" >&2; exit 1; fi
done
# Also scan wg0.conf
while grep -q "10.66.0.${NEXT}/32" /etc/wireguard/wg0.conf 2>/dev/null; do
  NEXT=$((NEXT + 1))
done

IPV4="10.66.0.${NEXT}"
IPV6="fd66:66:66::${NEXT}"

umask 077
wg genkey | tee "$PRIV" | wg pubkey > "$PUB"
wg genpsk > "$PSK"
chmod 600 "$PRIV" "$PUB" "$PSK"

PEER_PUB=$(cat "$PUB")
PEER_PRIV=$(cat "$PRIV")
PEER_PSK=$(cat "$PSK")
SERVER_PUB=$(cat /var/lib/vpn-project/secrets/wireguard/server_public.key)

cat >> /etc/wireguard/wg0.conf << EOF

# peer: ${NAME}
[Peer]
PublicKey = ${PEER_PUB}
PresharedKey = ${PEER_PSK}
AllowedIPs = ${IPV4}/32, ${IPV6}/128
EOF

wg set wg0 peer "$PEER_PUB" preshared-key "$PSK" allowed-ips "${IPV4}/32,${IPV6}/128"

CONF="$CLIENT_DIR/${NAME}.conf"
cat > "$CONF" << EOF
[Interface]
PrivateKey = ${PEER_PRIV}
Address = ${IPV4}/32, ${IPV6}/128
DNS = 10.66.0.1
MTU = 1280

[Peer]
PublicKey = ${SERVER_PUB}
PresharedKey = ${PEER_PSK}
Endpoint = 173.249.39.129:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF
chmod 600 "$CONF"
qrencode -o "$CLIENT_DIR/${NAME}.png" < "$CONF"
chmod 600 "$CLIENT_DIR/${NAME}.png"

python3 - "$NAME" "$IPV4" "$IPV6" << 'PY'
import json, sys, datetime
from pathlib import Path
name, ipv4, ipv6 = sys.argv[1], sys.argv[2], sys.argv[3]
Path('/var/lib/vpn-project/data/users').mkdir(parents=True, exist_ok=True)
Path(f'/var/lib/vpn-project/data/users/{name}.json').write_text(json.dumps({
  "id": name,
  "display_name": name,
  "group": "default",
  "status": "active",
  "created_at": datetime.datetime.now(datetime.UTC).strftime('%Y-%m-%dT%H:%M:%SZ'),
  "expires_at": None,
  "backends": {"primary": {
    "type": "wireguard",
    "ipv4": ipv4,
    "ipv6": ipv6,
    "public_key_file": f"/var/lib/vpn-project/secrets/wireguard/peers/{name}_public.key",
    "client_conf": f"/var/lib/vpn-project/secrets/wireguard/clients/{name}.conf"
  }},
  "notes": ""
}, indent=2) + "\n")
PY

echo "OK peer=$NAME ipv4=$IPV4"
echo "config: $CONF"
echo "QR: qrencode -t ansiutf8 < $CONF"
