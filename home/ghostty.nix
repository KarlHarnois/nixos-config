{ lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.ghostty = {
    enable = true;

    settings = {
      font-family = theme.font;
      font-style = "Regular";
      font-size = 11;
      window-padding-x = 14;
      window-padding-y = 14;
      window-decoration = false;
      confirm-close-surface = false;
      resize-overlay = "never";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      gtk-single-instance = true;
      quit-after-last-window-closed = false;
    };
  };

  wayland.windowManager.hyprland.settings.on = [
    {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("ghostty --initial-window=false")
          end'')
      ];
    }
  ];
}
