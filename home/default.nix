{ pkgs, ... }:

{
  home.packages = [
    pkgs.bluetui
    pkgs.cliamp
    pkgs.impala
  ];

  imports = [
    ./bash.nix
    ./btop.nix
    ./chromium.nix
    ./claude-code.nix
    ./dark-mode.nix
    ./firefox.nix
    ./fonts.nix
    ./fsel.nix
    ./git.nix
    ./hyprland
    ./mako.nix
    ./nvim
    ./ghostty.nix
    ./readline.nix
    ./screenshot.nix
    ./starship
    ./swayimg.nix
    ./tabiew.nix
    ./voxtype.nix
    ./wallpaper.nix
    ./waybar.nix
    ./wiremix.nix
    ./xdg.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home.stateVersion = "26.05";
}
