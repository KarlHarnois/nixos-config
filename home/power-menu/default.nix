{
  lib,
  pkgs,
  theme,
  ...
}:

let
  colors = lib.concatStringsSep "," [
    "fg:${theme.palette.foreground.hex}"
    "fg+:${theme.palette.foreground.hex}"
    "bg+:${theme.palette.surfaceLight.hex}"
    "hl:${theme.palette.accent.hex}"
    "hl+:${theme.palette.accent.hex}"
    "pointer:${theme.palette.accent.hex}"
    "header:${theme.palette.accent.hex}"
    "prompt:${theme.palette.separator.hex}"
  ];

  powerMenu = pkgs.writeShellApplication {
    name = "power-menu";

    runtimeInputs = [ pkgs.fzf ];

    text = ''
      export FZF_DEFAULT_OPTS="--color=${colors}"
    ''
    + builtins.readFile ./power-menu.sh;
  };
in
{
  home.packages = [ powerMenu ];
}
