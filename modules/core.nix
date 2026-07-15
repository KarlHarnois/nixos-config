{ pkgs, ... }:

{
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  networking.useDHCP = false;

  hardware.bluetooth.enable = true;

  time.timeZone = "America/Montreal";

  users.users.karl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
