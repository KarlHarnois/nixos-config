{ osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  xdg.configFile."btop/btop.conf".force = true;

  programs.btop = {
    enable = true;

    themes.custom = theme.apps.btop;

    settings = {
      color_theme = "custom";
      theme_background = false;
      vim_keys = true;
    };
  };
}
