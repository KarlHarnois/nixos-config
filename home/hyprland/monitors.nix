let
  ultrawide = {
    width = 3440;
    scale = 1.25;
  };

  # Monitors are positioned in logical pixels, so an output's footprint is its
  # pixel width divided by its scale. The ultrawide sits left of the laptop panel.
  ultrawidePosition = "-${toString (builtins.floor (ultrawide.width / ultrawide.scale))}x0";
in
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      }
      {
        output = "eDP-1";
        mode = "preferred";
        position = "0x0";
        scale = 2;
      }
      {
        output = "DP-1";
        mode = "preferred";
        position = ultrawidePosition;
        inherit (ultrawide) scale;
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
