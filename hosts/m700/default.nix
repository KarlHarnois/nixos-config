{
  imports = [ ./disk.nix ];

  networking = {
    hostName = "m700";
    interfaces.enp0s31f6.useDHCP = true;
  };

  virtualisation.windows-vm = {
    memory = "4G";
    cores = 2;
    diskSize = "64G";
  };

  system.stateVersion = "26.05";
}
