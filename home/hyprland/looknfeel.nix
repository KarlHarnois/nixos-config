{ osConfig, ... }:

let
  inherit (osConfig) theme;

  activeGeneralPreset = "flush";

  generalPresets = {
    flush = {
      gaps_in = -1;
      gaps_out = 0;
      border_size = 1;
    };

    inset = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 1;
    };
  };

  floatingPanelRule = {
    name = "floating-panels";
    match.class = "^(local\\.(bluetui|clipse|fsel|impala|wiremix)|1[pP]assword)$";
    float = true;
    center = true;
    size = "800 600";
  };

  powerMenuRule = {
    name = "power-menu";
    match.class = "^local\\.power-menu$";
    float = true;
    center = true;
    size = "400 260";
  };
in
{
  wayland.windowManager.hyprland.settings = {
    config = {
      general = generalPresets.${activeGeneralPreset} // {
        col = {
          active_border = theme.palette.accent.rgb;
          inactive_border = theme.palette.separator.rgba "aa";
        };
      };

      plugin.hyprmullion = {
        enabled = true;
        color = theme.palette.background.rgb;
        show_bar_border = theme.showBarBorder;
      };

      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = theme.palette.surface.rgba "ee";
        };

        blur.enabled = false;
      };
    };

    window_rule = [
      floatingPanelRule
      powerMenuRule
    ];
  };
}
