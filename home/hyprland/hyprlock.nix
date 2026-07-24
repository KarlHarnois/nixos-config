{ theme, ... }:

let
  inherit (import ../../themes/lib.nix) rgba;
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general.ignore_empty_input = true;

      animations.enabled = false;

      background = {
        monitor = "";
        color = rgba theme.palette.background "ff";
        path = "${theme.wallpaper}";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "650, 100";
        position = "0, 0";
        halign = "center";
        valign = "center";

        inner_color = rgba theme.palette.accent "4d";
        outer_color = rgba theme.palette.foreground "80";
        outline_thickness = 4;

        font_family = theme.font;
        font_color = rgba theme.palette.foreground "ff";

        placeholder_text = "Enter Password";
        check_color = rgba theme.palette.accent "ff";
        fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

        rounding = 0;
        shadow_passes = 0;
        fade_on_empty = false;
      };
    };
  };
}
