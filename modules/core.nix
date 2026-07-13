{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "America/Montreal";

  users.users.karl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
