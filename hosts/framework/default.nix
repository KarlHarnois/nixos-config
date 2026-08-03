{ config, ... }:

{
  imports = [ ./disk.nix ];

  networking.hostName = "framework";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.npu.enable = true;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 12;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [ "thunderbolt" ];
  };

  services = {
    logind.settings.Login.HandlePowerKey = "ignore";
    power-profiles-daemon.enable = true;
    thermald.enable = true;
    fprintd.enable = false;

    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
  };

  assertions = [
    {
      assertion = !config.services.tlp.enable;
      message = "power-profiles-daemon must suppress the TLP default from nixos-hardware";
    }
  ];

  system.stateVersion = "26.05";
}
