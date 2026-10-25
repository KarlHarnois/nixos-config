{ osConfig, ... }:

let
  inherit (osConfig.theme.palette)
    accent
    background
    foreground
    surface
    ;
in
{
  programs.qutebrowser.settings.colors = {
    hints = {
      fg = background.hex;
      bg = accent.hex;
      match.fg = foreground.hex;
    };

    keyhint = {
      fg = foreground.hex;
      bg = surface.hex;
      suffix.fg = accent.hex;
    };
  };
}
