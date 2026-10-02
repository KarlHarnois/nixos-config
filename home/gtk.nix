{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (osConfig) theme;

  inherit (theme) palette;
  inherit (theme.apps) gtk;

  colorScheme = "dark";

  surfaceColors = {
    window_bg_color = palette.background.hex;
    view_bg_color = palette.surface.hex;
    headerbar_bg_color = palette.surfaceLight.hex;
    sidebar_bg_color = palette.surfaceLight.hex;
    secondary_sidebar_bg_color = palette.surfaceLight.hex;
    card_bg_color = palette.surfaceLight.hex;
    dialog_bg_color = palette.surfaceLight.hex;
    popover_bg_color = palette.surfaceLight.hex;
    thumbnail_bg_color = palette.surfaceLight.hex;
    accent_bg_color = gtk.accent.hex;
  };

  foregroundColors = {
    window_fg_color = palette.foreground.hex;
    view_fg_color = palette.foreground.hex;
    headerbar_fg_color = palette.foreground.hex;
    sidebar_fg_color = palette.foreground.hex;
    secondary_sidebar_fg_color = palette.foreground.hex;
    card_fg_color = palette.foreground.hex;
    dialog_fg_color = palette.foreground.hex;
    popover_fg_color = palette.foreground.hex;
    thumbnail_fg_color = palette.foreground.hex;
    accent_color = gtk.accent.hex;
    accent_fg_color = gtk.accentForeground.hex;
  };

  colorDefinitions = lib.mapAttrsToList (name: value: "@define-color ${name} ${value};");

  paletteCss = lib.concatStringsSep "\n" (colorDefinitions (surfaceColors // foregroundColors));
in
lib.mkMerge [
  {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      inherit colorScheme;

      gtk3.extraCss = lib.mkIf (colorScheme == "dark") paletteCss;
      gtk4.extraCss = lib.mkIf (colorScheme == "dark") paletteCss;
    };
  }

  (lib.mkIf (theme.sansFont != null) {
    gtk.font.name = theme.sansFont.family;
  })
]
