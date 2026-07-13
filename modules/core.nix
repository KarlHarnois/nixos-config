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
    git
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
