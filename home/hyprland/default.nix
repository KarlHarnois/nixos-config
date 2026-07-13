{ ... }:

{
  imports = [
    ./looknfeel.nix
    ./animations.nix
    ./bindings.nix
    ./cursor.nix
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

        dwindle.preserve_split = true;

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        ecosystem.no_update_news = true;
      };
    };
  };
}
