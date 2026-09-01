SERVICE=docker-windows-vm.service
WEB_CONSOLE_URL=http://127.0.0.1:8006
RDP_ADDRESS=127.0.0.1:3389
RDP_CONNECT_TIMEOUT_SECONDS=180
SHORTEST_REAL_SESSION_SECONDS=30
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/windows-vm"
RDP_LOG_FILE="$STATE_DIR/xfreerdp.log"

require_password() {
  if [ ! -r "$WINDOWS_VM_PASSWORD_FILE" ]; then
    echo "[✘] $WINDOWS_VM_PASSWORD_FILE is not readable; check opnix-secrets.service" >&2
    exit 1
  fi
}

avoid_kerberos_lookup_stall() {
  local config="$STATE_DIR/krb5.conf"

  if [ ! -f "$config" ]; then
    printf '[libdefaults]\n  dns_lookup_kdc = false\n  dns_lookup_realm = false\n' >"$config"
  fi

  export KRB5_CONFIG="$config"
}

storage_is_empty() {
  [ -z "$(ls -A "$WINDOWS_VM_STORAGE_DIR" 2>/dev/null)" ]
}

start_first_install() {
  echo "[+] Starting the Windows VM for the first time..."
  systemctl start "$SERVICE"
  echo "[✔] Windows is installing itself; this takes 15-30 minutes unattended"
  echo "[+] Run windows-vm again once the installer reaches the desktop"
  open_web_console
}

open_web_console() {
  xdg-open "$WEB_CONSOLE_URL" 2>/dev/null || echo "[+] Watch the install at $WEB_CONSOLE_URL"
}

connect_rdp() {
  local deadline=$((SECONDS + RDP_CONNECT_TIMEOUT_SECONDS)) started

  while [ "$SECONDS" -lt "$deadline" ]; do
    require_running_service
    started="$SECONDS"

    if run_xfreerdp || was_real_session "$started"; then
      return 0
    fi

    require_accepted_credentials

    echo "[+] Windows is not accepting RDP yet; retrying..."
    sleep 5
  done

  echo "[✘] Gave up connecting over RDP; inspect $RDP_LOG_FILE, or watch $WEB_CONSOLE_URL if Windows is still installing" >&2
  return 1
}

was_real_session() {
  [ $((SECONDS - $1)) -gt "$SHORTEST_REAL_SESSION_SECONDS" ]
}

require_accepted_credentials() {
  if ! grep -qE 'ERRCONNECT_(AUTHENTICATION_FAILED|LOGON_FAILURE)' "$RDP_LOG_FILE"; then
    return 0
  fi

  echo "[✘] Windows rejected the password from $WINDOWS_VM_PASSWORD_FILE" >&2
  echo "[!] Leaving the VM running; sync the vault and guest passwords, then rerun windows-vm" >&2
  exit 1
}

require_running_service() {
  if ! systemctl is-active --quiet "$SERVICE"; then
    echo "[✘] $SERVICE is not running; inspect it with: journalctl -u $SERVICE" >&2
    exit 1
  fi
}

run_xfreerdp() {
  xfreerdp /args-from:fd:3 3< <(rdp_arguments) 2>"$RDP_LOG_FILE"
}

rdp_arguments() {
  printf '%s\n' \
    /v:"$RDP_ADDRESS" \
    /u:"$WINDOWS_VM_USER" \
    /p:"$(cat "$WINDOWS_VM_PASSWORD_FILE")" \
    /gfx:AVC444 \
    /dynamic-resolution \
    /clipboard \
    /sound:sys:pulse \
    /microphone \
    -grab-keyboard \
    "/floatbar:sticky:off,default:visible,show:fullscreen"

  rdp_scale
}

stop_vm_unless_declined() {
  local answer
  read -r -p "Stop the VM? [Y/n] " answer || answer=""

  case "$answer" in
  [nN]*)
    echo "[+] Leaving the VM running; run windows-vm to reconnect"
    ;;
  *)
    echo "[+] Stopping the VM; a Windows shutdown can take up to two minutes..."
    systemctl stop "$SERVICE"
    echo "[✔] VM stopped"
    ;;
  esac
}

rdp_scale() {
  command -v hyprctl >/dev/null || return 0

  local monitor_scale
  monitor_scale="$(hyprctl monitors -j 2>/dev/null | jq -r '[.[] | select(.focused)][0].scale // empty' || true)"
  [ -n "$monitor_scale" ] || return 0

  if awk -v scale="$monitor_scale" 'BEGIN { exit !(scale >= 1.7) }'; then
    echo /scale:180
  elif awk -v scale="$monitor_scale" 'BEGIN { exit !(scale >= 1.3) }'; then
    echo /scale:140
  fi
}

case "${1:-}" in
"" | --keep-alive) ;;
*)
  echo "usage: windows-vm [--keep-alive]" >&2
  exit 1
  ;;
esac

mkdir -p "$STATE_DIR"
require_password
avoid_kerberos_lookup_stall

if storage_is_empty; then
  start_first_install
  exit 0
fi

echo "[+] Starting the Windows VM..."
systemctl start "$SERVICE"

if ! connect_rdp; then
  echo "[!] Leaving the VM running so a first install can finish"
  exit 1
fi

if [ "${1:-}" = "--keep-alive" ]; then
  echo "[+] Leaving the VM running; stop it with: systemctl stop $SERVICE"
  exit 0
fi

stop_vm_unless_declined
