{ config, lib, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_mimeType: "firefox.desktop")
      // lib.genAttrs [
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/webp"
      ] (_mimeType: "swayimg.desktop")
      // {
        "text/plain" = "nvim-ghostty.desktop";
      };
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
    "d ${config.xdg.userDirs.documents}/Todo/Personal"
    "d ${config.xdg.userDirs.documents}/Todo/Work"
  ];
}
