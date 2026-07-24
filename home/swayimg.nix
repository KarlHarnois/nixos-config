{ pkgs, theme, ... }:

{
  home.packages = [ pkgs.swayimg ];

  xdg.configFile."swayimg/config" = {
    force = true;
    text = ''
      [viewer]
      window = ${theme.palette.background.hexAlpha "ff"}

      [gallery]
      window = ${theme.palette.background.hexAlpha "ff"}
      background = ${theme.palette.surface.hexAlpha "ff"}
      select = ${theme.palette.surfaceLight.hexAlpha "ff"}
      border_color = ${theme.palette.accent.hexAlpha "ff"}

      [font]
      name = ${theme.font}
      color = ${theme.palette.foreground.hexAlpha "ff"}

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
