remove_split_routes() {
  echo "[+] Removing split-tunnel routes..."

  if [ ! -f "$ROUTE_STATE" ]; then
    echo "[!] No route state file found; skipping route cleanup"
    return
  fi

  local addresses
  mapfile -t addresses <"$ROUTE_STATE"

  for address in "${addresses[@]}"; do
    if [ -n "$address" ]; then
      as_root ip route del "$address/32" dev "$interface" >/dev/null 2>&1 || true
    fi
  done

  as_root rm -f "$ROUTE_STATE"
}

tear_down_ipsec() {
  echo "[+] Tearing down IPsec (IKE/ESP)..."
  as_root ipsec down "$IPSEC_CONNECTION" >/dev/null 2>&1 || true
}

require_configuration

echo "[+] Disconnecting L2TP/PPP session..."
end_l2tp_session

wait_until 10 interface_is_gone ||
  echo "[!] $interface still present after disconnect; continuing cleanup"

remove_split_routes
tear_down_ipsec

echo "[✔] VPN down (L2TP/PPP stopped, routes cleaned, IPsec down)"
