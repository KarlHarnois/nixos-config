{ pkgs, ... }:

{
  home.packages = [ pkgs.nerd-fonts.iosevka-term ];
  fonts.fontconfig.enable = true;
}
