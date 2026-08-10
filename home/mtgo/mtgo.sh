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
exec xfreerdp \
  /v:"$address" \
  /u:"$ACCOUNT" \
  /d:"$DOMAIN" \
  /gfx:AVC444 \
  /dynamic-resolution \
  /clipboard \
  /sound:sys:pulse \
  /network:lan \
  +auto-reconnect
