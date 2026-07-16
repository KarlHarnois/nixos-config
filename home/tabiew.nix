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
      fg = "#${theme.accent}"
      bg = "#${theme.background}"

      [[table_headers]]
      fg = "#${theme.accent}"
      bg = "#${theme.background}"

      [[rows]]
      fg = "#${theme.foreground}"
      bg = "#${theme.background}"

      [[rows]]
      fg = "#${theme.foreground}"
      bg = "#${theme.surface}"

      [row_highlight]
      fg = "#${theme.background}"
      bg = "#${theme.accent}"

      [[table_tags]]
      fg = "#${theme.background}"
      bg = "#${theme.accent}"

      [[table_tags]]
      fg = "#${theme.background}"
      bg = "#${theme.separator}"

      [block]
      fg = "#${theme.separator}"
      bg = "#${theme.background}"

      [block_tag]
      fg = "#${theme.background}"
      bg = "#${theme.accent}"

      [text]
      fg = "#${theme.foreground}"
      bg = "#${theme.background}"

      [text_highlighted]
      fg = "#${theme.foreground}"
      bg = "#${theme.separator}"

      [subtext]
      fg = "#${theme.accent}"
      bg = "#${theme.background}"

      [error]
      fg = "#${theme.background}"
      bg = "#${theme.foreground}"

      [gutter]
      fg = "#${theme.separator}"
      bg = "#${theme.background}"

      [[chart]]
      fg = "#${theme.accent}"
      bg = "#${theme.background}"

      [[chart]]
      fg = "#${theme.foreground}"
      bg = "#${theme.background}"
    '';
  };
}
