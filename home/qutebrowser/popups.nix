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

  alert = {
    fg = accent.hex;
    bg = surface.hex;
    border = accent.hex;
  };

  selected = {
    fg = foreground.hex;
    bg = surfaceLight.hex;
  };
in
{
  programs.qutebrowser.settings.colors = {
    messages = {
      info = {
        fg = foreground.hex;
        bg = surface.hex;
        border = surfaceLight.hex;
      };
      warning = alert;
      error = alert;
    };

    prompts = {
      fg = foreground.hex;
      bg = surface.hex;
      border = "1px solid ${surfaceLight.hex}";
      inherit selected;
    };

    contextmenu = {
      menu = {
        fg = foreground.hex;
        bg = surface.hex;
      };
      inherit selected;
    };

    downloads = {
      bar.bg = background.hex;
      start.bg = separator.hex;
      stop.bg = accent.hex;
      error.bg = accent.hex;
    };
  };
}
