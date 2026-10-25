{ lib, osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  imports = [
    ./battery.nix
    ./clock.nix
    ./voxtype.nix
    ./volume.nix
    ./workspaces.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 20;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ ];
      modules-right = [
        "custom/voxtype"
        "pulseaudio"
        "battery"
        "clock"
      ];
    };

    style = lib.mkBefore ''
      @define-color foreground ${theme.palette.foreground.hex};
      @define-color background ${theme.palette.background.hex};
      @define-color muted mix(@foreground, @background, 0.3);
      @define-color accent ${theme.palette.accent.hex};
      @define-color alert ${theme.palette.alert.hex};

      * {
        background-color: transparent;
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: '${theme.font}';
        font-size: 14.67px;
      }

      window#waybar {
        background-color: mix(@background, @foreground, 0.07);
        color: @muted;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #custom-voxtype,
      #pulseaudio,
      #battery,
      #clock {
        padding: 0 8px;
      }

      tooltip {
        background-color: @background;
        padding: 2px;
      }
    '';
  };
}
