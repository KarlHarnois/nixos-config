{ pkgs, ... }:

let
  theme = import ./theme.nix;
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
    text = ''
      [table_header]
      fg = "#${theme.palette.accent}"
      bg = "#${theme.palette.background}"

      [[table_headers]]
      fg = "#${theme.palette.accent}"
      bg = "#${theme.palette.background}"

      [[rows]]
      fg = "#${theme.palette.foreground}"
      bg = "#${theme.palette.background}"

      [[rows]]
      fg = "#${theme.palette.foreground}"
      bg = "#${theme.palette.surface}"

      [row_highlight]
      fg = "#${theme.palette.background}"
      bg = "#${theme.palette.accent}"

      [[table_tags]]
      fg = "#${theme.palette.background}"
      bg = "#${theme.palette.accent}"

      [[table_tags]]
      fg = "#${theme.palette.background}"
      bg = "#${theme.palette.separator}"

      [block]
      fg = "#${theme.palette.separator}"
      bg = "#${theme.palette.background}"

      [block_tag]
      fg = "#${theme.palette.background}"
      bg = "#${theme.palette.accent}"

      [text]
      fg = "#${theme.palette.foreground}"
      bg = "#${theme.palette.background}"

      [text_highlighted]
      fg = "#${theme.palette.foreground}"
      bg = "#${theme.palette.separator}"

      [subtext]
      fg = "#${theme.palette.accent}"
      bg = "#${theme.palette.background}"

      [error]
      fg = "#${theme.palette.background}"
      bg = "#${theme.palette.foreground}"

      [gutter]
      fg = "#${theme.palette.separator}"
      bg = "#${theme.palette.background}"

      [[chart]]
      fg = "#${theme.palette.accent}"
      bg = "#${theme.palette.background}"

      [[chart]]
      fg = "#${theme.palette.foreground}"
      bg = "#${theme.palette.background}"
    '';
  };
}
