{ lib, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.ghostty = {
    enable = true;

    settings = {
      background = "#${theme.background}";
      foreground = "#${theme.foreground}";
      cursor-color = "#${theme.cursor}";
      selection-background = "#${theme.selectionBackground}";
      selection-foreground = "#${theme.selectionForeground}";
      palette = lib.imap0 (index: color: "${toString index}=#${color}") theme.colors;

      font-family = theme.font;
      font-style = "Regular";
      font-size = 11;
      window-theme = "ghostty";
      window-padding-x = 14;
      window-padding-y = 14;
      window-decoration = false;
      gtk-toolbar-style = "flat";
      confirm-close-surface = false;
      resize-overlay = "never";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor,ssh-env";
      gtk-single-instance = true;
      quit-after-last-window-closed = false;
      mouse-scroll-multiplier = 0.95;
      async-backend = "epoll";

      keybind = [
        "shift+insert=paste_from_clipboard"
        "control+insert=copy_to_clipboard"
      ];
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
