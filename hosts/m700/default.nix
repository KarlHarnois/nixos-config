{
  imports = [ ./disk.nix ];

  networking = {
    hostName = "m700";
    interfaces.eno1.useDHCP = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  nix.settings.max-jobs = 1;

  programs.ringleader.memoryHigh = "4G";

  virtualisation.windows-vm = {
    memory = "4G";
    cores = 2;
    diskSize = "64G";
  };

  system.stateVersion = "26.05";
}
