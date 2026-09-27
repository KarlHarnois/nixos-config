{ pkgs, ... }:

{
  home.packages = [ pkgs.cameractrls-gtk4 ];

  systemd.user.services.cameractrlsd = {
    Unit = {
      Description = "CameraCtrls daemon - restore control values";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service.ExecStart = "${pkgs.cameractrls-gtk4}/bin/cameractrlsd";

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
