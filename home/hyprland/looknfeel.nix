let
  theme = import ../theme.nix;
  inherit (import ../themes/lib.nix) rgb rgba;
in
{
  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        col = {
          active_border = rgb theme.palette.accent;
          inactive_border = rgba theme.palette.separator "aa";
        };
      };

      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = rgba theme.palette.surface "ee";
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
        match.class = "^(com.mitchellh.ghostty|local\\..+)$";
        opacity = "0.97 0.9";
      }
      {
        name = "floating-panels";
        match.class = "^(local\\.(bluetui|fsel|impala|wiremix)|1[pP]assword)$";
        float = true;
        center = true;
        size = "800 600";
      }
    ];
  };
}
