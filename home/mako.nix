{ pkgs, ... }:

let
  theme = import ./theme.nix;

  notificationHistory = pkgs.writeShellScriptBin "notification-history" ''
    history_file=$(${pkgs.coreutils}/bin/mktemp --suffix=.json)
    trap '${pkgs.coreutils}/bin/rm -f "$history_file"' EXIT

    ${pkgs.mako}/bin/makoctl history -j \
      | ${pkgs.jq}/bin/jq 'map({id, app: .app_name, urgency, summary, body})' \
      > "$history_file"

    ${pkgs.tabiew}/bin/tw -f json "$history_file"
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
