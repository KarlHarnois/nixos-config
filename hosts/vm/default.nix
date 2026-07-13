{ ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;
    forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
    qemu.options = [
      "-device virtio-vga-gl,xres=3440,yres=1440"
      "-display gtk,gl=on,zoom-to-fit=on,full-screen=on,show-menubar=off"
      "-audiodev pa,id=snd0"
      "-device virtio-sound-pci,audiodev=snd0"
    ];
  };

  system.stateVersion = "26.05";
}
