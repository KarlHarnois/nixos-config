HOST="${MTGO_HOST:-mtgo-toaster.home.arpa}"
ACCOUNT="${MTGO_USER:-Lenovo}"
DOMAIN="${MTGO_DOMAIN:-mtgo-toaster}"

address="$(getent ahostsv4 "$HOST" | awk '{print $1; exit}' || true)"

if [ -z "$address" ]; then
  echo "[✘] could not resolve IPv4 for $HOST" >&2
  exit 1
fi

# /gfx:AVC444 needs AVC444ModePreferred and AVCHardwareEncodePreferred set to 1 on the
# Windows host under HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services.
xfreerdp \
  /v:"$address" \
  /u:"$ACCOUNT" \
  /d:"$DOMAIN" \
  /gfx:AVC444 \
  /dynamic-resolution \
  /scale-desktop:140 \
  /clipboard \
  /sound:sys:pulse \
  /network:lan \
  +auto-reconnect || true

# TermService leaks committed memory until RDP logons fail, so a fresh boot per
# session keeps the box reachable. Decline after an unexpected drop to keep the
# session alive and reconnect instead.
read -r -p "Reboot the MTGO box? [Y/n] " answer
case "$answer" in
  [nN]*) ;;
  *)
    ssh -o HostName="$address" -o StrictHostKeyChecking=accept-new \
      mtgo-toaster "shutdown /r /t 0"
    ;;
esac
