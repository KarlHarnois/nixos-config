{ pkgs, ... }:

let
  theme = import ./theme.nix;
  inherit (import ./themes/lib.nix) hexAlpha;
in
{
  home.packages = [ pkgs.swayimg ];

  xdg.configFile."swayimg/config" = {
    force = true;
    text = ''
      [viewer]
      window = ${hexAlpha theme.palette.background "ff"}

      [gallery]
      window = ${hexAlpha theme.palette.background "ff"}
      background = ${hexAlpha theme.palette.surface "ff"}
      select = ${hexAlpha theme.palette.surfaceLight "ff"}
      border_color = ${hexAlpha theme.palette.accent "ff"}

      [font]
      name = ${theme.font}
      color = ${hexAlpha theme.palette.foreground "ff"}

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
