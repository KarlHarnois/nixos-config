{
  pkgs,
  lib,
  username,
  ...
}:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "claude-code"
    ];

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = true;
      Network.NameResolvingService = "resolvconf";
    };
  };

  networking.useDHCP = false;

  hardware.bluetooth.enable = true;

  zramSwap.enable = true;

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "America/Montreal";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  environment.shellAliases.rebuild = lib.mkDefault "sudo nixos-rebuild switch --flake .";

  environment.systemPackages = with pkgs; [
    git
    gnumake
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
