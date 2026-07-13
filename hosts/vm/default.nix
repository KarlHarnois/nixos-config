{ ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  boot.kernelParams = [ "video=Virtual-1:1280x800" ];

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
    forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
    qemu.options = [
      "-device virtio-vga-gl"
      "-display gtk,gl=on,zoom-to-fit=on,full-screen=on,show-menubar=off"
      "-audiodev pa,id=snd0"
      "-device virtio-sound-pci,audiodev=snd0"
    ];
  };

  system.stateVersion = "26.05";
}
