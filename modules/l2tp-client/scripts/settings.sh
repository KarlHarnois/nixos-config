STATE_DIR=/var/lib/l2tp

require_configuration() {
  if [ ! -r "$STATE_DIR/settings" ]; then
    echo "[✘] $STATE_DIR/settings not found; run vpn-install first" >&2
    exit 1
  fi

  # shellcheck source=/dev/null
  . "$STATE_DIR/settings"

  require_setting IPSEC_CONNECTION
  require_setting L2TP_TUNNEL
  require_setting INTERFACE
}

require_setting() {
  if [ -z "${!1:-}" ]; then
    echo "[✘] $1 is not set in $STATE_DIR/settings; re-run vpn-install" >&2
    exit 1
  fi
}
