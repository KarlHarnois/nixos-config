{ pkgs, ... }:

let
  theme = import ./theme.nix;

  notificationHistory = pkgs.writeShellScriptBin "notification-history" ''
    ${pkgs.mako}/bin/makoctl history | ${pkgs.less}/bin/less
  '';
in
{
  home.packages = [ pkgs.libnotify notificationHistory ];

  services.mako = {
    enable = true;

    settings = {
      font = "${theme.font} 11";
      background-color = "#${theme.surface}";
      text-color = "#${theme.foreground}";
      border-color = "#${theme.separator}";
      border-size = 2;
      border-radius = 0;
      width = 400;
      padding = "8";
      default-timeout = 5000;
      max-history = 100;

      "urgency=low".default-timeout = 3000;

      "urgency=critical" = {
        default-timeout = 0;
        border-color = "#${theme.accent}";
      };

      "mode=do-not-disturb".invisible = 1;
    };
  };
}
