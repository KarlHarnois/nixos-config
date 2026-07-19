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

      [keys.viewer]
      Ctrl+Equal = zoom +10
      Ctrl+Plus = zoom +10
      Ctrl+Minus = zoom -10

      [keys.gallery]
      h = step_left
      j = step_down
      k = step_up
      l = step_right
    '';
  };
}
