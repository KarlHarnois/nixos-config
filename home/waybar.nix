{ lib, pkgs, ... }:

let
  theme = import ./theme.nix;

  pinnedWorkspaceCount = 5;
  pinnedWorkspaces = map toString (lib.range 1 pinnedWorkspaceCount);

  voxtypeStatusStream = pkgs.writeShellScript "voxtype-status-stream" ''
    trap 'kill 0' EXIT
    ${pkgs.voxtype-onnx}/bin/voxtype status --follow --extended --format json \
      | ${lib.getExe pkgs.jq} --unbuffered --compact-output '. + {alt: .class}'
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [
        "clock"
        "custom/voxtype"
      ];
      modules-right = [ "battery" ];

      "hyprland/workspaces" = {
        format = "{icon}";

        format-icons = {
          "10" = "0";
          active = "󱓻";
        };

        persistent-workspaces = lib.genAttrs pinnedWorkspaces (_: [ ]);
      };

      clock = {
        format = "{:L%B %d, %H:%M}";
        tooltip = false;
      };

      "custom/voxtype" = {
        exec = voxtypeStatusStream;
        return-type = "json";
        format = "{icon}";

        format-icons = {
          idle = "";
          recording = "󰍬";
          transcribing = "󰔟";
        };
      };

      battery = {
        format = "{capacity}% {icon}";
        format-full = "󰂅";

        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        interval = 5;
        tooltip = false;

        states = {
          warning = 20;
          critical = 10;
        };
      };
    };

    style = ''
      @define-color foreground #${theme.palette.accent};
      @define-color background #${theme.palette.surface};

      * {
        background-color: @background;
        color: @foreground;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: '${theme.font}';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #custom-voxtype {
        min-width: 12px;
        margin-left: 7.5px;
      }
    '';
  };
}
