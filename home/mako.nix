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
      background-color = "#${theme.background}";
      text-color = "#${theme.accent}";
      border-color = "#${theme.accent}";
      border-size = 2;
      border-radius = 0;
      width = 420;
      padding = "10";
      outer-margin = 20;
      max-icon-size = 32;
      default-timeout = 5000;
      max-history = 100;

      "urgency=low".default-timeout = 3000;

      "urgency=critical" = {
        default-timeout = 0;
        layer = "overlay";
      };

      "mode=do-not-disturb".invisible = 1;
    };
  };
}
