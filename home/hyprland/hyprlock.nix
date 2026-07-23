let
  theme = import ../theme.nix;

  color = hex: alpha: "rgba(${hex}${alpha})";
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general.ignore_empty_input = true;

      animations.enabled = false;

      background = {
        monitor = "";
        color = color theme.background "ff";
        path = "${theme.wallpaper}";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "650, 100";
        position = "0, 0";
        halign = "center";
        valign = "center";

        inner_color = color theme.accent "4d";
        outer_color = color theme.foreground "80";
        outline_thickness = 4;

        font_family = theme.font;
        font_color = color theme.foreground "ff";

        placeholder_text = "Enter Password";
        check_color = color theme.accent "ff";
        fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

        rounding = 0;
        shadow_passes = 0;
        fade_on_empty = false;
      };
    };
  };
}
