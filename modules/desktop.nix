{ pkgs, ... }:

{
  programs.hyprland.enable = true;

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
