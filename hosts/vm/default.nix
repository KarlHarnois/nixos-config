{ ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  virtualisation.vmVariant = {
    services.openssh.enable = true;
    users.users.karl.initialPassword = "nixos";

    environment.shellAliases.rebuild =
      let toplevel = "~/nixos-config#nixosConfigurations.vm.config.virtualisation.vmVariant.system.build.toplevel";
      in ''sudo "$(nix build --no-link --print-out-paths ${toplevel})/bin/switch-to-configuration" test'';

    virtualisation = {
      memorySize = 8192;
      cores = 4;
      forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
      sharedDirectories.config = {
        source = "/home/karl/Documents/hobby/nixos-config";
        target = "/home/karl/nixos-config";
      };
      qemu.options = [
        "-display gtk,gl=on,zoom-to-fit=on,full-screen=on,show-menubar=off"
        "-audiodev pa,id=snd0"
        "-device virtio-sound-pci,audiodev=snd0"
      ];
    };
  };

  system.stateVersion = "26.05";
}
