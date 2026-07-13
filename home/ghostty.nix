{ ... }:

let
  theme = import ./theme.nix;
in
{
  programs.ghostty = {
    enable = true;

    settings = {
      font-family = theme.font;
      font-style = "Regular";
      font-size = 11;
      window-padding-x = 14;
      window-padding-y = 14;
      window-decoration = false;
      confirm-close-surface = false;
      resize-overlay = "never";
    };
  };
}
