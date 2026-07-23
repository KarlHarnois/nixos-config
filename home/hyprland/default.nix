{
  imports = [
    ./looknfeel.nix
    ./animations.nix
    ./bindings.nix
    ./cursor.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings = {
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      };

      config = {
        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "ctrl:nocaps";
        };

        dwindle = {
          preserve_split = true;
          force_split = 2;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        ecosystem.no_update_news = true;

        xwayland.force_zero_scaling = true;
      };
    };
  };
}
