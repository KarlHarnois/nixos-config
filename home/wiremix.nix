{ pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  home.packages = [ pkgs.wiremix ];

  xdg.configFile."wiremix/wiremix.toml" = {
    force = true;
    text = ''
      theme = "custom"

      [themes.custom]
      inherit = "default"

      selector = { fg = "#${theme.foreground}" }

      tab_selected = { fg = "#${theme.foreground}" }
      tab_marker = { fg = "#${theme.accent}" }
      list_more = { fg = "#${theme.separator}" }

      volume_empty = { fg = "#${theme.separator}" }
      volume_filled = { fg = "#${theme.foreground}" }

      meter_inactive = { fg = "#${theme.separator}" }
      meter_active = { fg = "#${theme.accent}" }
      meter_overload = { fg = "#${theme.foreground}" }
      meter_center_inactive = { fg = "#${theme.separator}" }
      meter_center_active = { fg = "#${theme.accent}" }

      dropdown_selected = { fg = "#${theme.accent}", add_modifier = "REVERSED" }
      dropdown_more = { fg = "#${theme.separator}" }

      help_more = { fg = "#${theme.separator}" }
    '';
  };
}
