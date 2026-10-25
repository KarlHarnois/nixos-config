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
in
{
  programs.qutebrowser.settings.colors.completion = {
    fg = foreground.hex;
    odd.bg = surface.hex;
    even.bg = background.hex;
    category = {
      fg = accent.hex;
      bg = background.hex;
      border.top = background.hex;
      border.bottom = background.hex;
    };
    item.selected = {
      fg = foreground.hex;
      bg = surfaceLight.hex;
      border.top = surfaceLight.hex;
      border.bottom = surfaceLight.hex;
      match.fg = accent.hex;
    };
    match.fg = accent.hex;
    scrollbar = {
      fg = separator.hex;
      bg = background.hex;
    };
  };
}
