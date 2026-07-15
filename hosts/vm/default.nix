{ ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  virtualisation.vmVariant = {
    services.openssh.enable = true;
    users.users.karl.initialPassword = "nixos";

    virtualisation = {
      memorySize = 8192;
      cores = 4;
      forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
      qemu.options = [
        "-display gtk,gl=on,zoom-to-fit=on,full-screen=on,show-menubar=off"
        "-audiodev pa,id=snd0"
        "-device virtio-sound-pci,audiodev=snd0"
      ];
    };
  };

  system.stateVersion = "26.05";
}
