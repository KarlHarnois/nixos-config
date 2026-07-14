{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./bash.nix
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
