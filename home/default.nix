{ pkgs, ... }:

{
  home.packages = [
    pkgs.bluetui
    pkgs.brightnessctl
    pkgs.cliamp
    pkgs.impala
    pkgs.playerctl
  ];

  imports = [
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./chromium.nix
    ./claude-code.nix
    ./clipboard.nix
    ./dark-mode.nix
    ./direnv.nix
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
