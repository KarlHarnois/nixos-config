{
  writeShellApplication,
  symlinkJoin,
  coreutils,
  gawk,
  gnugrep,
  iproute2,
  procps,
}:

let
  stateDir = "/var/lib/l2tp";
  controlSocket = "/var/run/xl2tpd/l2tp-control";
  routeStateFile = "/run/l2tp-routes.txt";

  kernelFacingTools = [
    coreutils
    gawk
    gnugrep
    iproute2
    procps
  ];

  preamble = ''
    if [ "$EUID" -eq 0 ]; then
      as_root() { "$@"; }
    else
      as_root() { sudo "$@"; }
    fi

    if [ ! -r ${stateDir}/settings ]; then
      echo "[✘] ${stateDir}/settings not found; run vpn-install first" >&2
      exit 1
    fi

    # shellcheck source=/dev/null
    . ${stateDir}/settings

    interface="''${PPP_IFACE:-$INTERFACE}"
  '';
in
symlinkJoin {
  name = "l2tp-commands";
  paths = [

    (writeShellApplication {
      name = "vpn-up";
      runtimeInputs = kernelFacingTools;
      text = ''
        ${preamble}

        echo "[+] Starting IPsec (IKE/ESP encryption)..."
        as_root ipsec up "$IPSEC_CONNECTION"

        echo "[+] Ensuring no stale L2TP session is active..."
        if [ -e "${controlSocket}" ]; then
          echo "d $L2TP_TUNNEL" | as_root tee "${controlSocket}" >/dev/null || true
          sleep 2
        fi

        as_root pkill -f "pppd.*pppol2tp" >/dev/null 2>&1 || true
        sleep 1

        echo "[+] Starting L2TP/PPP session via xl2tpd..."
        if [ ! -e "${controlSocket}" ]; then
          echo "[✘] xl2tpd control socket not found; is xl2tpd running?" >&2
          as_root systemctl status xl2tpd --no-pager || true
          exit 1
        fi
        echo "c $L2TP_TUNNEL" | as_root tee "${controlSocket}" >/dev/null

        echo "[+] Waiting for $interface to exist and have an IPv4 address..."
        deadline=$((SECONDS + 60))
        while true; do
          if ip link show "$interface" >/dev/null 2>&1 &&
            ip -4 addr show dev "$interface" | grep -q " inet "; then
            break
          fi

          if [ "$SECONDS" -ge "$deadline" ]; then
            echo "[✘] $interface never became usable (no IPv4). Dumping recent logs..." >&2
            as_root journalctl -u xl2tpd -n 200 --no-pager || true
            pgrep -a pppd || true
            ip link show "$interface" 2>/dev/null || true
            ip -4 addr show dev "$interface" 2>/dev/null || true
            exit 1
          fi

          sleep 1
        done

        echo "[+] $interface is ready; installing split-tunnel routes..."
        as_root sh -c ": >'${routeStateFile}'"

        mapfile -t hosts <${stateDir}/routed-hosts

        for host in "''${hosts[@]}"; do
          if [ -z "$host" ]; then
            continue
          fi

          addresses="$(getent ahostsv4 "$host" | awk '{print $1}' | sort -u || true)"

          if [ -z "$addresses" ]; then
            echo "[!] Could not resolve IPv4 for $host (skipping)"
            continue
          fi

          while IFS= read -r address; do
            if [ -n "$address" ]; then
              as_root ip route replace "$address/32" dev "$interface" || true
              echo "$address" | as_root tee -a "${routeStateFile}" >/dev/null
            fi
          done <<<"$addresses"
        done

        echo "[+] Verifying split routes installed..."
        if ! ip route show dev "$interface" | grep -q .; then
          echo "[✘] No routes installed on $interface; split tunnel is NOT active." >&2
          exit 1
        fi

        echo "[✔] VPN up (IPsec + L2TP/PPP, split tunnel active)"
      '';
    })

    (writeShellApplication {
      name = "vpn-down";
      runtimeInputs = kernelFacingTools;
      text = ''
        ${preamble}

        echo "[+] Disconnecting L2TP/PPP session..."
        if [ -e "${controlSocket}" ]; then
          echo "d $L2TP_TUNNEL" | as_root tee "${controlSocket}" >/dev/null || true
        else
          echo "[!] xl2tpd control socket not found; skipping xl2tpd disconnect"
        fi

        sleep 2
        as_root pkill -f "pppd.*pppol2tp" >/dev/null 2>&1 || true

        deadline=$((SECONDS + 10))
        while ip link show "$interface" >/dev/null 2>&1; do
          if [ "$SECONDS" -ge "$deadline" ]; then
            echo "[!] $interface still present after disconnect; continuing cleanup"
            break
          fi

          sleep 1
        done

        echo "[+] Removing split-tunnel routes..."
        if [ -f "${routeStateFile}" ]; then
          while IFS= read -r address; do
            if [ -n "$address" ]; then
              as_root ip route del "$address/32" dev "$interface" >/dev/null 2>&1 || true
            fi
          done <"${routeStateFile}"

          as_root rm -f "${routeStateFile}"
        else
          echo "[!] No route state file found; skipping route cleanup"
        fi

        echo "[+] Tearing down IPsec (IKE/ESP)..."
        as_root ipsec down "$IPSEC_CONNECTION" >/dev/null 2>&1 || true

        echo "[✔] VPN down (L2TP/PPP stopped, routes cleaned, IPsec down)"
      '';
    })

    (writeShellApplication {
      name = "vpn-check";
      runtimeInputs = kernelFacingTools;
      text = ''
        ${preamble}

        if [ $# -ne 1 ]; then
          echo "usage: vpn-check <hostname-or-url>" >&2
          exit 1
        fi

        input="$1"
        host="''${input#*://}"
        host="''${host%%/*}"

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
      '';
    })

  ];
}
