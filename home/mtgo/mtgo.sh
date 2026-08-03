HOST="${MTGO_HOST:-mtgo-toaster.local}"
ACCOUNT="${MTGO_USER:-Lenovo}"
DOMAIN="${MTGO_DOMAIN:-mtgo-toaster}"

address="$(getent ahostsv4 "$HOST" | awk '{print $1; exit}' || true)"

if [ -z "$address" ]; then
  echo "[✘] could not resolve IPv4 for $HOST" >&2
  exit 1
fi

exec xfreerdp \
  /v:"$address" \
  /u:"$ACCOUNT" \
  /d:"$DOMAIN" \
  /dynamic-resolution \
  /clipboard \
  /sound:sys:pulse \
  /network:lan \
  /cert:ignore \
  +auto-reconnect
