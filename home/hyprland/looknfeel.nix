{ ... }:

let
  theme = import ../theme.nix;
in
{
  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        col = {
          active_border = "rgb(${theme.foreground})";
          inactive_border = "rgba(${theme.inactiveBorder})";
        };
      };

      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = "rgba(${theme.shadow})";
        };

        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          brightness = 0.60;
          contrast = 0.75;
        };
      };
    };

    window_rule = [
      {
        name = "terminal-opacity";
        match.class = "^(kitty|cliamp)$";
        opacity = "0.97 0.9";
      }
    ];
  };
}
