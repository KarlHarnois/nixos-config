{ osConfig, ... }:

let
  inherit (osConfig) theme;

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
      general.col = {
        active_border = theme.focusedBorder.rgb;
        inactive_border = theme.palette.separator.rgb;
      };

      decoration = {
        shadow.enabled = false;

        blur.enabled = false;
      };
    };

    window_rule = [
      floatingPanelRule
      powerMenuRule
    ];
  };
}
