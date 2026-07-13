{ ... }:

{
  services.hyprpaper = {
    enable = true;
    settings.splash = false;
    settings.wallpaper = [
      {
        monitor = "";
        path = "${./wallpapers/matte-black.jpg}";
        fit_mode = "cover";
      }
    ];
  };
}
