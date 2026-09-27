{ lib, osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  home.packages = [
    theme.fontPackage
  ]
  ++ lib.optional (theme.sansFont != null) theme.sansFont.package;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = lib.mkIf (theme.sansFont != null) {
      sansSerif = [ theme.sansFont.family ];
      monospace = [ theme.font ];
    };
  };
}
