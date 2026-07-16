{ pkgs, ... }:

let
  theme = import ../home/theme.nix;
in
{
  programs.hyprland.enable = true;

  programs.chromium = {
    enable = true;
    extraOpts = {
      BrowserColorScheme = "dark";
      BrowserThemeColor = "#${theme.background}";
    };
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "karl";
      };
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd start-hyprland";
    };
  };
}
