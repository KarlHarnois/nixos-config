{ pkgs, ... }:

let
  accessPointConf = pkgs.writeText "wifi-sandbox-ap.conf" ''
    interface=wlan0
    driver=nl80211
    hw_mode=g
    channel=0
    ieee80211n=1
    wmm_enabled=1
    ssid=sandbox
    auth_algs=1
    wpa=2
    wpa_key_mgmt=WPA-PSK-SHA256
    wpa_pairwise=CCMP
    rsn_pairwise=CCMP
    ieee80211w=1
    wpa_passphrase=sandbox123
  '';
in
{
  boot.kernelModules = [ "mac80211_hwsim" ];

  systemd.services.iwd.serviceConfig.ExecStart = [
    ""
    "${pkgs.iwd}/libexec/iwd --nophys phy0"
  ];

  systemd.services.wifi-sandbox-ap = {
    description = "Simulated wifi access point";
    wantedBy = [ "multi-user.target" ];
    bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
    after = [ "sys-subsystem-net-devices-wlan0.device" ];
    serviceConfig = {
      ExecStart = "${pkgs.hostapd}/bin/hostapd ${accessPointConf}";
      Restart = "on-failure";
    };
  };

  networking.interfaces.wlan0.ipv4.addresses = [
    {
      address = "192.168.50.1";
      prefixLength = 24;
    }
  ];

  networking.firewall.interfaces.wlan0.allowedUDPPorts = [ 67 ];

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "wlan0";
      bind-interfaces = true;
      port = 0;
      dhcp-range = "192.168.50.10,192.168.50.99,1h";
    };
  };
}
