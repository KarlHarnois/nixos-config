{ pkgs, ... }:

# The VM has no bluetooth hardware, so bluetoothd cannot start and bluetui
# errors out. Emulate controllers with the kernel's virtual HCI driver and
# bluez's btvirt, which nixpkgs does not ship but builds behind the
# --enable-testing flag. Two controllers share the same virtual air, giving
# the first one a discoverable peer.
let
  btvirt = pkgs.bluez.overrideAttrs (previous: {
    configureFlags = previous.configureFlags ++ [ "--enable-testing" ];
    postInstall = (previous.postInstall or "") + ''
      install -Dm755 emulator/btvirt $out/bin/btvirt
    '';
  });
in
{
  boot.kernelModules = [ "hci_vhci" ];

  systemd.services.bluetooth-sandbox = {
    description = "Virtual bluetooth controllers";
    wantedBy = [ "multi-user.target" ];
    before = [ "bluetooth.service" ];
    serviceConfig = {
      ExecStart = "${btvirt}/bin/btvirt -l2";
      Restart = "on-failure";
    };
  };
}
