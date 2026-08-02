{
  config,
  lib,
  username,
  ...
}:

{
  imports = [ ./disk.nix ];

  networking.hostName = "framework";

  hardware.enableRedistributableFirmware = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 12;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" ];
  };

  services = {
    logind.settings.Login.HandlePowerKey = "ignore";
    power-profiles-daemon.enable = true;
    thermald.enable = true;

    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
  };

  home-manager.users.${username}.wayland.windowManager.hyprland.settings.monitor.scale =
    lib.mkForce 2;

  assertions = [
    {
      assertion = !config.services.tlp.enable;
      message = "power-profiles-daemon must suppress the TLP default from nixos-hardware";
    }
  ];

  system.stateVersion = "26.05";
}
