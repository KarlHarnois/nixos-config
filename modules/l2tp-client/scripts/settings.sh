STATE_DIR=/var/lib/l2tp

require_configuration() {
  if [ ! -r "$STATE_DIR/settings" ]; then
    echo "[✘] $STATE_DIR/settings not found; run vpn-install first" >&2
    exit 1
  fi

  # shellcheck source=/dev/null
  . "$STATE_DIR/settings"
}
