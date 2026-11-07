{ lib, ... }:

let
  numberedWorkspaces = map toString (lib.range 1 9);
  numberedWorkspaceIcons = lib.genAttrs numberedWorkspaces lib.id;
in
{
  programs.waybar = {
    settings.mainBar."hyprland/workspaces" = {
      format = "{icon}";
      format-icons = numberedWorkspaceIcons // {
        "10" = "0";
      };
      all-outputs = true;
    };

    style = ''
      #workspaces button {
        all: initial;
        margin-top: -1px;
        margin-bottom: -1px;
        color: @muted;
      }

      #workspaces button:nth-child(odd) {
        padding: 0 8px;
      }

      #workspaces button:nth-child(even) {
        padding: 0 7px 0 8px;
      }

      #workspaces button.active {
        color: @accent;
        font-weight: bold;
      }

      #workspaces button.urgent {
        color: @alert;
      }
    '';
  };
}
