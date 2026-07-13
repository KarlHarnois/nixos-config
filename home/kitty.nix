{ ... }:

let
  theme = import ./theme.nix;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = theme.font;
      size = 11.0;
    };

    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 14;
      placement_strategy = "top-left";
      hide_window_decorations = "yes";
    };
  };
}
