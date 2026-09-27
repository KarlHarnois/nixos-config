{ lib, osConfig, ... }:

let
  inherit (osConfig) theme;
in
lib.mkMerge [
  {
    home.packages = [ theme.fontPackage ];
    fonts.fontconfig.enable = true;
  }

  (lib.mkIf (theme.sansFont != null) {
    home.packages = [ theme.sansFont.package ];

    fonts.fontconfig.defaultFonts = {
      sansSerif = [ theme.sansFont.family ];
      monospace = [ theme.font ];
    };

    dconf.settings."org/gnome/desktop/interface".font-name = "${theme.sansFont.family} 11";
  })
]
