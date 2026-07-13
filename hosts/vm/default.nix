{ ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
    forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
    qemu.options = [ "-vga virtio" ];
  };

  system.stateVersion = "26.05";
}
