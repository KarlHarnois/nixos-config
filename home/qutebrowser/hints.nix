{ osConfig, ... }:

let
  inherit (osConfig.theme.palette)
    accent
    background
    foreground
    separator
    surface
    ;
in
{
  programs.qutebrowser.settings = {
    hints.border = "1px solid ${foreground.hex}";

    colors = {
      hints = {
        fg = foreground.hex;
        bg = background.hex;
        match.fg = separator.hex;
      };

      keyhint = {
        fg = foreground.hex;
        bg = surface.hex;
        suffix.fg = accent.hex;
      };
    };
  };
}
