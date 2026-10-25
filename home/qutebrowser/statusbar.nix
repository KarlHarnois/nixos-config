{ osConfig, ... }:

let
  inherit (osConfig.theme.palette)
    accent
    background
    foreground
    separator
    surface
    surfaceLight
    ;

  highlighted = {
    fg = background.hex;
    bg = accent.hex;
  };
in
{
  programs.qutebrowser.settings.colors.statusbar = {
    normal = {
      fg = foreground.hex;
      bg = background.hex;
    };
    insert = highlighted;
    caret = highlighted;
    command = {
      fg = foreground.hex;
      bg = background.hex;
    };
    passthrough = {
      fg = foreground.hex;
      bg = surfaceLight.hex;
    };
    private = {
      fg = foreground.hex;
      bg = surface.hex;
    };
    progress.bg = accent.hex;
    url = {
      fg = foreground.hex;
      success.https.fg = foreground.hex;
      success.http.fg = separator.hex;
      hover.fg = accent.hex;
      warn.fg = accent.hex;
      error.fg = accent.hex;
    };
  };
}
