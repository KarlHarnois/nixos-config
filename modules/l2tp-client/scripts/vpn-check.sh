hostname_from() {
  local without_scheme=${1#*://}
  echo "${without_scheme%%/*}"
}

if [ $# -ne 1 ]; then
  echo "usage: vpn-check <hostname-or-url>" >&2
  exit 1
fi

require_configuration

host="$(hostname_from "$1")"
address="$(getent ahostsv4 "$host" | awk '{print $1; exit}')"

if [ -z "$address" ]; then
  echo "❌ could not resolve IPv4 for $host"
  exit 2
fi

route="$(ip route get "$address")"

echo "$host → $address"

if echo "$route" | grep -q "dev $interface"; then
  echo "✅ routed via VPN ($interface)"
else
  echo "❌ not routed via VPN"
fi

echo "route: $route"
