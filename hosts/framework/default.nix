{ config, pkgs, ... }:

{
  imports = [ ./disk.nix ];

  networking.hostName = "framework";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.npu.enable = true;
    framework.laptop13.audioEnhancement.enable = true;
  };

  console = {
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
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
    hardware.bolt.enable = true;

    upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };

    # Lithium cells age from sitting at a high charge and this laptop is plugged
    # in nearly all the time. The attribute comes from framework-laptop-kmod.
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT1", ATTR{charge_control_end_threshold}="80"
    '';
  };

  virtualisation.windows-vm = {
    memory = "8G";
    cores = 4;
    diskSize = "64G";
  };

  assertions = [
    {
      assertion = !config.services.tlp.enable;
      message = "power-profiles-daemon must suppress the TLP default from nixos-hardware";
    }
  ];

  system.stateVersion = "26.05";
}
