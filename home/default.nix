{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./hyprland
    ./kitty.nix
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.stateVersion = "26.05";
}
