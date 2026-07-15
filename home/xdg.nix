{ config, ... }:

{
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
