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
        padding: 0 0.5em;
        color: @foreground;
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
