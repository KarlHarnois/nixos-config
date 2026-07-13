{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./fonts.nix
    ./hyprland
    ./ghostty.nix
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.stateVersion = "26.05";
}
