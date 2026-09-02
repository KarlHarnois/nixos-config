{ username, ... }:

{
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "preferred";
        position = "auto-right";
        scale = 2;
      }
    ];

    env = [
      {
        _args = [
          "GDK_SCALE"
          "2"
        ];
      }
    ];
  };
}
