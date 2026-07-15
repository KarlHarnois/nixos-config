{ lib, ... }:

let
  theme = import ./theme.nix;

  pinnedWorkspaceCount = 5;
  pinnedWorkspaces = map toString (lib.range 1 pinnedWorkspaceCount);
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
      modules-center = [ "clock" ];

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
    };

    style = ''
      @define-color foreground #${theme.accent};
      @define-color background #${theme.surface};

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

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }
    '';
  };
}
