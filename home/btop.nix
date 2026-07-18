let
  theme = import ./theme.nix;
in
{
  xdg.configFile."btop/btop.conf".force = true;

  programs.btop = {
    enable = true;

    themes.darkthrone = theme.btop;

    settings = {
      color_theme = "darkthrone";
      theme_background = false;
      vim_keys = true;
    };
  };
}
