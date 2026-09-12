{ lib, ... }:

let
  pinnedWorkspaceCount = 5;
  pinnedWorkspaces = map toString (lib.range 1 pinnedWorkspaceCount);
in
{
  programs.waybar = {
    settings.mainBar."hyprland/workspaces" = {
      format = "{icon}";

      format-icons = {
        "10" = "0";
        active = "󱓻";
      };

      persistent-workspaces = lib.genAttrs pinnedWorkspaces (_: [ ]);
    };

    style = ''
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
