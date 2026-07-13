{ pkgs, ... }:

{
  home.packages = [ pkgs.cliamp ];

  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./wallpaper.nix
  ];

  home.stateVersion = "26.05";
}
