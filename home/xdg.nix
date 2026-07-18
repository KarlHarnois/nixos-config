{ config, lib, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ] (_mimeType: "firefox.desktop");
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    music = null;
    publicShare = null;
    templates = null;
    videos = null;
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.userDirs.projects}/Personal"
    "d ${config.xdg.userDirs.projects}/Work"
  ];
}
