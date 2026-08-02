start_ipsec() {
  echo "[+] Starting IPsec (IKE/ESP encryption)..."
  as_root ipsec up "$IPSEC_CONNECTION"
}

clear_stale_session() {
  echo "[+] Ensuring no stale L2TP session is active..."
  end_l2tp_session
  sleep 1
}

start_l2tp_session() {
  echo "[+] Starting L2TP/PPP session via xl2tpd..."

  if [ ! -e "$CONTROL_SOCKET" ]; then
    echo "[✘] xl2tpd control socket not found; is xl2tpd running?" >&2
    as_root systemctl status xl2tpd --no-pager || true
    exit 1
  fi

  control c
}

report_unusable_interface() {
  echo "[✘] $INTERFACE never became usable (no IPv4). Dumping recent logs..." >&2
  as_root journalctl -u xl2tpd -n 200 --no-pager || true
  pgrep -a pppd || true
  ip -4 addr show dev "$INTERFACE" 2>/dev/null || true
  exit 1
}

route_host() {
  local addresses
  addresses="$(getent ahostsv4 "$1" | awk '{print $1}' | sort -u || true)"

  if [ -z "$addresses" ]; then
    echo "[!] Could not resolve IPv4 for $1 (skipping)"
    return
  fi

  local resolved
  mapfile -t resolved <<<"$addresses"

  for address in "${resolved[@]}"; do
    if [ -n "$address" ]; then
      as_root ip route replace "$address/32" dev "$INTERFACE" || true
      echo "$address" | as_root tee -a "$ROUTE_STATE" >/dev/null
    fi
  done
}

install_split_routes() {
  echo "[+] $INTERFACE is ready; installing split-tunnel routes..."
  as_root truncate -s 0 "$ROUTE_STATE"

  local hosts
  mapfile -t hosts <"$STATE_DIR/routed-hosts"

  for host in "${hosts[@]}"; do
    if [ -n "$host" ]; then
      route_host "$host"
    fi
  done
}

verify_split_routes() {
  echo "[+] Verifying split routes installed..."

  if ! ip route show dev "$INTERFACE" | grep -q .; then
    echo "[✘] No routes installed on $INTERFACE; split tunnel is NOT active." >&2
    exit 1
  fi
}

require_configuration
start_ipsec
clear_stale_session
start_l2tp_session

echo "[+] Waiting for $INTERFACE to exist and have an IPv4 address..."
wait_until 60 interface_has_address || report_unusable_interface

install_split_routes
verify_split_routes

echo "[✔] VPN up (IPsec + L2TP/PPP, split tunnel active)"
