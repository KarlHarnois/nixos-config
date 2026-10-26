{ osConfig, ... }:

let
  inherit (osConfig) theme;
in
{
  imports = [
    ./1password.nix
    ./completion.nix
    ./focus-indicator.nix
    ./hints.nix
    ./google.nix
    ./insert-mode.nix
    ./popups.nix
    ./quickmarks.nix
    ./scrolling.nix
    ./statusbar.nix
    ./tabs.nix
  ];

  programs.qutebrowser = {
    enable = true;

    settings = {
      colors.webpage = {
        bg = theme.palette.background.hex;
        preferred_color_scheme = "dark";
        darkmode.enabled = true;
      };

      url = {
        start_pages = [ "about:blank" ];
        default_page = "about:blank";
      };

      fonts = {
        default_family = theme.font;
        default_size = "11pt";
      };
    };
  };
}
