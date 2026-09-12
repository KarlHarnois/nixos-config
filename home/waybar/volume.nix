{ lib, pkgs, ... }:

{
  programs.waybar.settings.mainBar.pulseaudio = {
    format = "VOL {volume}%";
    format-muted = "VOL muted";
    tooltip = false;
    on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
  };
}
