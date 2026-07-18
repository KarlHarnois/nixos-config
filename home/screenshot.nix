{ pkgs, ... }:

{
  home.packages = [
    pkgs.grimblast
    pkgs.satty
    pkgs.wl-clipboard
  ];
}
