{ config, osConfig, ... }:

let
  inherit (osConfig) theme;

  settings = {
    gui.theme = {
      activeBorderColor = [
        theme.palette.accent.hex
        "bold"
      ];
      inactiveBorderColor = [ theme.palette.separator.hex ];
      selectedLineBgColor = [ theme.palette.surfaceLight.hex ];
      optionsTextColor = [ theme.palette.accent.hex ];
    };
  };
in
{
  programs.lazydocker = {
    enable = true;

    inherit settings;
  };

  home.file."${config.xdg.configHome}/lazydocker/config.yml".force = true;
}
