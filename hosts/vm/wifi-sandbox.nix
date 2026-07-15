{ pkgs, ... }:

{
  boot.kernelModules = [ "mac80211_hwsim" ];

  systemd.services.iwd.serviceConfig.ExecStart = [
    ""
    "${pkgs.iwd}/libexec/iwd --nophys phy0"
  ];

  services.hostapd = {
    enable = true;
    radios.wlan0.networks.wlan0 = {
      ssid = "sandbox";
      authentication = {
        mode = "wpa2-sha256";
        wpaPassword = "sandbox123";
      };
    };
  };

  networking.interfaces.wlan0.ipv4.addresses = [
    { address = "192.168.50.1"; prefixLength = 24; }
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
