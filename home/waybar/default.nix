{ lib, osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  imports = [
    ./session.nix
    ./voxtype.nix
    ./workspaces.nix
  ];

  designSystem.waybar.colors = lib.optionalAttrs (!theme.designSystemColors) {
    "color.surface.base" = theme.palette.background.hex;
    "color.border.default" = theme.palette.separator.hex;
    "color.text.primary" = theme.palette.foreground.hex;
    "color.text.secondary" = "mix(@color_text_primary, @color_surface_base, 0.3)";
    "color.text.inverse" = theme.palette.background.hex;
    "color.focus" = theme.palette.accent.hex;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      modules-left = [
        "custom/session"
        "hyprland/workspaces"
      ];
      modules-right = [
        "custom/screen-recording"
        "custom/voxtype"
        "group/status"
        "group/clock"
      ];
    };

    style = lib.mkOrder 600 ''
      @define-color foreground @color_text_primary;
      @define-color background @color_surface_base;
      @define-color accent @color_focus;
      @define-color alert ${theme.palette.alert.hex};
    '';
  };
}
