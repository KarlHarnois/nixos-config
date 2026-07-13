{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "karl";
      };
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
    };
  };

  environment.systemPackages = with pkgs; [
    kitty
  ];
}
