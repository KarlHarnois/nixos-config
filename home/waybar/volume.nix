{ lib, pkgs, ... }:

{
  programs.waybar.settings.mainBar.pulseaudio = {
    format = "vol:{volume}%";
    format-muted = "vol:mute";
    tooltip = false;
    on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
  };
}
