{ theme, ... }:

{
  imports = [
    ./battery.nix
    ./clock.nix
    ./ollama.nix
    ./voxtype.nix
    ./volume.nix
    ./workspaces.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [
        "clock"
        "custom/voxtype"
      ];
      modules-right = [
        "custom/ollama"
        "pulseaudio"
        "battery"
      ];
    };

    style = ''
      @define-color accent ${theme.palette.accent.hex};
      @define-color surface ${theme.palette.surface.hex};

      * {
        background-color: @surface;
        color: @accent;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: '${theme.font}';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }
    '';
  };
}
