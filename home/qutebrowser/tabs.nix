{ lib, osConfig, ... }:

let
  inherit (osConfig.theme.palette)
    accent
    background
    foreground
    separator
    surface
    ;

  unfocused = {
    fg = separator.hex;
    bg = background.hex;
  };

  focused = {
    fg = foreground.hex;
    bg = surface.hex;
  };

  numberedTabKeys = lib.listToAttrs (
    map (tab: lib.nameValuePair "<Ctrl-${toString tab}>" "tab-focus ${toString tab}") (lib.range 1 8)
  );
in
{
  programs.qutebrowser = {
    settings.colors.tabs = {
      bar.bg = background.hex;
      odd = unfocused;
      even = unfocused;
      selected.odd = focused;
      selected.even = focused;
      indicator = {
        start = separator.hex;
        stop = accent.hex;
        error = accent.hex;
      };
    };

    keyBindings.normal = numberedTabKeys // {
      "<Ctrl-9>" = "tab-focus -1";
    };
  };
}
