{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (osConfig) theme;

  ghosttyTheme = theme.apps.ghostty;

  themeFileSetting = lib.optionalAttrs (ghosttyTheme.theme != null) {
    theme = "${pkgs.fetchFromGitHub ghosttyTheme.theme.repo}/${ghosttyTheme.theme.themeFile}";
  };

  lineHeightSetting =
    lib.optionalAttrs (ghosttyTheme.lineHeightPercent != null && ghosttyTheme.lineHeightPercent != 100)
      {
        adjust-cell-height = "${toString (ghosttyTheme.lineHeightPercent - 100)}%";
      };
in
{
  programs.ghostty = {
    enable = true;

    settings =
      themeFileSetting
      // lineHeightSetting
      // {
        background = theme.palette.background.hex;
        foreground = theme.palette.foreground.hex;
        palette = theme.apps.ghostty.palette;

        font-family = theme.font;
        font-style = "Regular";
        font-size = 11;
        window-theme = "ghostty";
        window-padding-x = 14;
        window-padding-y = 14;
        gtk-toolbar-style = "flat";
        confirm-close-surface = false;
        resize-overlay = "never";
        app-notifications = "no-clipboard-copy";
        cursor-style = "block";
        cursor-style-blink = false;
        shell-integration-features = "no-cursor,ssh-env";
        copy-on-select = "clipboard";
        gtk-single-instance = true;
        quit-after-last-window-closed = false;
        mouse-scroll-multiplier = 0.95;
        async-backend = "epoll";

        keybind = [
          "shift+insert=paste_from_clipboard"
          "control+insert=copy_to_clipboard"
          "ctrl+shift+space=write_screen_file:open"
        ];
      };
  };

  xdg.desktopEntries.nvim-ghostty = {
    name = "Neovim (Ghostty)";
    exec = "ghostty -e nvim + %f";
    noDisplay = true;
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
