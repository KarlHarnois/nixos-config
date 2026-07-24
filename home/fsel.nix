{ pkgs, theme, ... }:

{
  home.packages = [ pkgs.fsel ];

  xdg.configFile."fsel/config.toml" = {
    force = true;
    text = ''
      detach = true
      terminal_launcher = "ghostty -e"
      rounded_borders = false

      highlight_color = "#${theme.palette.accent}"
      header_title_color = "#${theme.palette.accent}"
      main_border_color = "#${theme.palette.separator}"
      apps_border_color = "#${theme.palette.separator}"
      input_border_color = "#${theme.palette.separator}"
      main_text_color = "#${theme.palette.foreground}"
      apps_text_color = "#${theme.palette.foreground}"
      input_text_color = "#${theme.palette.foreground}"

      [keybinds]
      down = ["down", { key = "j", modifiers = "ctrl" }]
      up = ["up", { key = "k", modifiers = "ctrl" }]
    '';
  };
}
