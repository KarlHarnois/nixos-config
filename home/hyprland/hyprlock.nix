{ theme, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general.ignore_empty_input = true;

      animations.enabled = false;

      background = {
        monitor = "";
        color = theme.palette.background.rgba "ff";
        path = "${theme.wallpaper}";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "650, 100";
        position = "0, 0";
        halign = "center";
        valign = "center";

        inner_color = theme.palette.accent.rgba "4d";
        outer_color = theme.palette.foreground.rgba "80";
        outline_thickness = 4;

        font_family = theme.font;
        font_color = theme.palette.foreground.rgba "ff";

        placeholder_text = "Enter Password";
        check_color = theme.palette.accent.rgba "ff";
        fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

        rounding = 0;
        shadow_passes = 0;
        fade_on_empty = false;
      };
    };
  };
}
