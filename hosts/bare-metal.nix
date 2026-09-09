{ config, ... }:

{
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

  assertions = [
    {
      assertion = config.swapDevices != [ ];
      message = "bare-metal hosts must set `swapDevices`: zram has no overflow of its own";
    }
  ];
}
