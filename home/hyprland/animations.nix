{ lib, osConfig, ... }:

let
  disabledAnimations = [
    {
      leaf = "global";
      enabled = false;
    }
  ];
in
{
  wayland.windowManager.hyprland.settings.animation = lib.mkIf (
    !osConfig.theme.animations
  ) disabledAnimations;
}
