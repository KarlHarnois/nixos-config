{ pkgs, ... }:

{
  home.packages = [ pkgs.bluetui pkgs.cliamp pkgs.impala ];

  imports = [
    ./bash.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./hyprland
    ./nvim
    ./ghostty.nix
    ./starship
    ./wallpaper.nix
    ./waybar.nix
    ./xdg.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home.stateVersion = "26.05";
}
