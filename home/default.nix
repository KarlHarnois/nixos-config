{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./fonts.nix
    ./git.nix
    ./hyprland
    ./nvim
    ./ghostty.nix
    ./starship
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.stateVersion = "26.05";
}
