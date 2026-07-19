{ pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  home.packages = [ pkgs.swayimg ];

  xdg.configFile."swayimg/config" = {
    force = true;
    text = ''
      [viewer]
      window = #${theme.background}ff

      [gallery]
      window = #${theme.background}ff
      background = #${theme.surface}ff
      select = #${theme.surfaceLight}ff
      border_color = #${theme.accent}ff

      [font]
      name = ${theme.font}
      color = #${theme.foreground}ff
    '';
  };
}
