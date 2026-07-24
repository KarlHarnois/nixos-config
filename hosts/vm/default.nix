{ username, ... }:

{
  imports = [ ../../modules ];

  networking.hostName = "nixos-vm";

  virtualisation.vmVariant =
    let
      configDir = "/mnt/nixos-config";
    in
    {
      services.openssh.enable = true;
      users.users.${username}.initialPassword = "nixos";

      environment.shellAliases.rebuild =
        let
          toplevel = "${configDir}#vmToplevel";
        in
        ''sudo "$(nix build --no-link --print-out-paths ${toplevel})/bin/switch-to-configuration" test'';

      imports = [
        ./battery-sandbox.nix
        ./bluetooth-sandbox.nix
        ./display-scale.nix
        ./wifi-sandbox.nix
      ];

      networking.interfaces.eth0.useDHCP = true;

      virtualisation = {
        diskSize = 32 * 1024;
        msize = 262144;
        memorySize = 8192;
        cores = 4;
        forwardPorts = [
          {
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }
        ];
        sharedDirectories.config = {
          source = ''"''${NIXOS_CONFIG_DIR:?launch the VM with make vm}"'';
          target = configDir;
        };
        qemu.options = [
          "-device virtio-tablet-pci"
          "-display gtk,gl=on,zoom-to-fit=on,full-screen=on,show-menubar=off"
          "-audiodev pa,id=snd0"
          "-device virtio-sound-pci,audiodev=snd0"
        ];
      };
    };

  system.stateVersion = "26.05";
}
