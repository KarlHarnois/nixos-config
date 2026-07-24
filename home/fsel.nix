{ pkgs, theme, ... }:

{
  home.packages = [ pkgs.fsel ];

  xdg.configFile."fsel/config.toml" = {
    force = true;
    text = ''
      detach = true
      terminal_launcher = "ghostty -e"
      rounded_borders = false

      highlight_color = "${theme.palette.accent.hex}"
      header_title_color = "${theme.palette.accent.hex}"
      main_border_color = "${theme.palette.separator.hex}"
      apps_border_color = "${theme.palette.separator.hex}"
      input_border_color = "${theme.palette.separator.hex}"
      main_text_color = "${theme.palette.foreground.hex}"
      apps_text_color = "${theme.palette.foreground.hex}"
      input_text_color = "${theme.palette.foreground.hex}"

      [keybinds]
      down = ["down", { key = "j", modifiers = "ctrl" }]
      up = ["up", { key = "k", modifiers = "ctrl" }]
    '';
  };
}
