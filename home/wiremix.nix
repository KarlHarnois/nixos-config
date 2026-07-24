{ pkgs, theme, ... }:

{
  home.packages = [ pkgs.wiremix ];

  xdg.configFile."wiremix/wiremix.toml" = {
    force = true;
    text = ''
      theme = "custom"

      [themes.custom]
      inherit = "default"

      selector = { fg = "#${theme.palette.foreground}" }

      tab_selected = { fg = "#${theme.palette.foreground}" }
      tab_marker = { fg = "#${theme.palette.accent}" }
      list_more = { fg = "#${theme.palette.separator}" }

      volume_empty = { fg = "#${theme.palette.separator}" }
      volume_filled = { fg = "#${theme.palette.foreground}" }

      meter_inactive = { fg = "#${theme.palette.separator}" }
      meter_active = { fg = "#${theme.palette.accent}" }
      meter_overload = { fg = "#${theme.palette.foreground}" }
      meter_center_inactive = { fg = "#${theme.palette.separator}" }
      meter_center_active = { fg = "#${theme.palette.accent}" }

      dropdown_selected = { fg = "#${theme.palette.accent}", add_modifier = "REVERSED" }
      dropdown_more = { fg = "#${theme.palette.separator}" }

      help_more = { fg = "#${theme.palette.separator}" }
    '';
  };
}
