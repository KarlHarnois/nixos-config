{ pkgs, ... }:

let
  cursorTheme = "Adwaita";
  cursorSize = 24;
in
{
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = cursorTheme;
    size = cursorSize;
    hyprcursor.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    config.cursor = {
      hide_on_key_press = true;
      warp_on_change_workspace = 1;
    };

    env = [
      { _args = [ "XCURSOR_THEME" cursorTheme ]; }
      { _args = [ "XCURSOR_SIZE" (toString cursorSize) ]; }
      { _args = [ "HYPRCURSOR_SIZE" (toString cursorSize) ]; }
    ];
  };
}
