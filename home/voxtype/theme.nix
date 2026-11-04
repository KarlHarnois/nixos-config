{ osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  xdg.configFile."voxtype/theme/colors.toml" = {
    force = true;
    text = ''
      background = "${theme.palette.background.hex}"
      foreground = "${theme.palette.foreground.hex}"
      accent = "${theme.palette.accent.hex}"
      color1 = "${theme.apps.voxtype.meterHigh.hex}"
      color2 = "${theme.apps.voxtype.meterLow.hex}"
      color3 = "${theme.apps.voxtype.meterMid.hex}"
    '';
  };
}
