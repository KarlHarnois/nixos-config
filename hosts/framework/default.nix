{ config, ... }:

{
  imports = [ ./disk.nix ];

  networking.hostName = "framework";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" ];
  };

  services = {
    logind.settings.Login.HandlePowerKey = "ignore";
    power-profiles-daemon.enable = true;
    thermald.enable = true;
  };

  assertions = [
    {
      assertion = !config.services.tlp.enable;
      message = "power-profiles-daemon must suppress the TLP default from nixos-hardware";
    }
  ];

  system.stateVersion = "26.05";
}
