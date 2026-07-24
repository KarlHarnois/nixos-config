{ pkgs, theme, ... }:

{
  home.packages = [ pkgs.wiremix ];

  xdg.configFile."wiremix/wiremix.toml" = {
    force = true;
    text = ''
      theme = "custom"

      [themes.custom]
      inherit = "default"

      selector = { fg = "${theme.palette.foreground.hex}" }

      tab_selected = { fg = "${theme.palette.foreground.hex}" }
      tab_marker = { fg = "${theme.palette.accent.hex}" }
      list_more = { fg = "${theme.palette.separator.hex}" }

      volume_empty = { fg = "${theme.palette.separator.hex}" }
      volume_filled = { fg = "${theme.palette.foreground.hex}" }

      meter_inactive = { fg = "${theme.palette.separator.hex}" }
      meter_active = { fg = "${theme.palette.accent.hex}" }
      meter_overload = { fg = "${theme.palette.foreground.hex}" }
      meter_center_inactive = { fg = "${theme.palette.separator.hex}" }
      meter_center_active = { fg = "${theme.palette.accent.hex}" }

      dropdown_selected = { fg = "${theme.palette.accent.hex}", add_modifier = "REVERSED" }
      dropdown_more = { fg = "${theme.palette.separator.hex}" }

      help_more = { fg = "${theme.palette.separator.hex}" }
    '';
  };
}
