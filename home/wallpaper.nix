let
  theme = import ./theme.nix;
in
{
  services.hyprpaper = {
    enable = true;
    settings.splash = false;
    settings.wallpaper = [
      {
        monitor = "";
        path = "${theme.wallpaper}";
        fit_mode = "cover";
      }
    ];
  };
}
