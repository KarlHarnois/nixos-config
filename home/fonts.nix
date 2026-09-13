{ osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  home.packages = [ theme.fontPackage ];
  fonts.fontconfig.enable = true;
}
