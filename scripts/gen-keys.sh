#!/usr/bin/env bash
# Generate secrets into /var/lib/vpn-project/secrets — never print private material to git paths
set -euo pipefail

SEC="/var/lib/vpn-project/secrets"
mkdir -p "$SEC"
chmod 700 "$SEC"

usage() {
  cat <<EOF
Usage: $0 <ed25519|wg|password|token> [name]

  ed25519 [name]  SSH-style ed25519 keypair → secrets/id_ed25519_<name>{,.pub}
  wg [name]       WireGuard keypair → secrets/wg_<name>{,_pub}
  password [name] random password file → secrets/password_<name>
  token [name]    random url-safe token → secrets/token_<name>
EOF
}

umask 077
kind="${1:-}"
name="${2:-default}"

case "$kind" in
  ed25519)
    out="$SEC/id_ed25519_${name}"
    if [[ -e "$out" ]]; then echo "exists: $out" >&2; exit 1; fi
    ssh-keygen -t ed25519 -N "" -f "$out" -C "vpn-project-${name}"
    chmod 600 "$out" "${out}.pub"
    echo "created $out and ${out}.pub"
    ;;
  wg)
    if ! command -v wg >/dev/null 2>&1; then
      echo "wg not installed yet; generating via openssl raw (install wireguard-tools later to verify)" >&2
      priv="$SEC/wg_${name}"
      # placeholder 32-byte key base64 (not a substitute for wg genkey long-term)
      head -c 32 /dev/urandom | base64 -w0 > "$priv"
      echo "created raw $priv (replace with wg genkey when tools available)"
    else
      priv="$SEC/wg_${name}"
      pub="$SEC/wg_${name}_pub"
      wg genkey | tee "$priv" | wg pubkey > "$pub"
      chmod 600 "$priv" "$pub"
      echo "created $priv and $pub"
    fi
    ;;
  password)
    out="$SEC/password_${name}"
    if [[ -e "$out" ]]; then echo "exists: $out" >&2; exit 1; fi
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32 > "$out"
    echo >> "$out"
    chmod 600 "$out"
    echo "created $out"
    ;;
  token)
    out="$SEC/token_${name}"
    if [[ -e "$out" ]]; then echo "exists: $out" >&2; exit 1; fi
    head -c 32 /dev/urandom | base64 -w0 | tr '+/' '-_' | tr -d '=' > "$out"
    echo >> "$out"
    chmod 600 "$out"
    echo "created $out"
    ;;
  *)
    usage
    exit 1
    ;;
esac
