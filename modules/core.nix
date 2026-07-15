{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "America/Montreal";

  users.users.karl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
