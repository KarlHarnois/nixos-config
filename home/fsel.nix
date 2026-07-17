{ pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  home.packages = [ pkgs.fsel ];

  xdg.configFile."fsel/config.toml" = {
    force = true;
    text = ''
      detach = true
      terminal_launcher = "ghostty -e"
      rounded_borders = false

      highlight_color = "#${theme.accent}"
      header_title_color = "#${theme.accent}"
      main_border_color = "#${theme.separator}"
      apps_border_color = "#${theme.separator}"
      input_border_color = "#${theme.separator}"
      main_text_color = "#${theme.foreground}"
      apps_text_color = "#${theme.foreground}"
      input_text_color = "#${theme.foreground}"
    '';
  };
}
