{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./fonts.nix
    ./hyprland
    ./neovim.nix
    ./ghostty.nix
    ./starship
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.stateVersion = "26.05";
}
