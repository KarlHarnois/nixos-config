CONTROL_SOCKET=/var/run/xl2tpd/l2tp-control
ROUTE_STATE=/run/l2tp-routes.txt

if [ "$EUID" -eq 0 ]; then
  as_root() { "$@"; }
else
  as_root() { sudo "$@"; }
fi

control() {
  echo "$1 $L2TP_TUNNEL" | as_root tee "$CONTROL_SOCKET" >/dev/null
}

end_l2tp_session() {
  if [ -e "$CONTROL_SOCKET" ]; then
    control d || true
    sleep 2
  fi

  as_root pkill -f "pppd.*pppol2tp" >/dev/null 2>&1 || true
}

interface_has_address() {
  ip link show "$interface" >/dev/null 2>&1 &&
    ip -4 addr show dev "$interface" | grep -q " inet "
}

interface_is_gone() {
  ! ip link show "$interface" >/dev/null 2>&1
}

wait_until() {
  local deadline=$((SECONDS + $1))
  shift

  until "$@"; do
    if [ "$SECONDS" -ge "$deadline" ]; then
      return 1
    fi

    sleep 1
  done
}
