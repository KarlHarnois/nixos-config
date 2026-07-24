{ pkgs, theme, ... }:

let
  colors = fg: bg: {
    fg = "#${fg}";
    bg = "#${bg}";
  };

  inherit (theme.palette)
    accent
    background
    foreground
    surface
    separator
    ;

  customTheme = {
    table_header = colors accent background;
    table_headers = [ (colors accent background) ];
    rows = [
      (colors foreground background)
      (colors foreground surface)
    ];
    row_highlight = colors background accent;
    table_tags = [
      (colors background accent)
      (colors background separator)
    ];
    block = colors separator background;
    block_tag = colors background accent;
    text = colors foreground background;
    text_highlighted = colors foreground separator;
    subtext = colors accent background;
    error = colors background foreground;
    gutter = colors separator background;
    chart = [
      (colors accent background)
      (colors foreground background)
    ];
  };

  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.tabiew ];

  xdg.configFile."tabiew/config.toml" = {
    force = true;
    text = ''
      theme = "Custom"
    '';
  };

  xdg.configFile."tabiew/theme.toml" = {
    force = true;
    source = tomlFormat.generate "tabiew-theme.toml" customTheme;
  };
}
