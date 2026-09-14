{ osConfig, ... }:

let
  inherit (osConfig) theme;

  inherit (theme.palette)
    accent
    foreground
    separator
    ;
in
{
  programs.bash.shellAliases.about = "fastfetch";

  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "builtin";
        source = "nixos";
        padding.right = 2;
        color = {
          "1" = accent.hex;
          "2" = foreground.hex;
          "3" = accent.hex;
          "4" = foreground.hex;
          "5" = accent.hex;
          "6" = foreground.hex;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = accent.hex;
          title = accent.hex;
          output = foreground.hex;
          separator = separator.hex;
        };
        key = {
          type = "string";
        };
        size.binaryPrefix = "si";
      };

      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "localip"
        "battery"
        "break"
        "colors"
      ];
    };
  };
}
