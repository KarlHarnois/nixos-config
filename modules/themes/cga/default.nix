{ pkgs, ... }:

let
  wallpaper =
    pkgs.runCommand "cga-wallpaper.png"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick -size 1x1 xc:'#0000aa' "$out"
      '';

  nibbleRepo = {
    owner = "cmoscofian";
    repo = "nibble-vim";
    rev = "7bc65491c4672aa389ab5c15209751f51af4f0b9";
    hash = "sha256-pAnR+3h1eqlxOAXLE9LYUVL08FtaWNI2s/HZI7Da7eU=";
  };
in
{
  theme = {
    font = "Terminess Nerd Font Mono";

    fontPackage = pkgs.nerd-fonts.terminess-ttf;

    transparency = false;

    animations = false;

    inherit wallpaper;

    palette = {
      accent = "55ffff";
      foreground = "aaaaaa";
      background = "0000aa";
      surface = "000000";
      surfaceLight = "5555ff";
      separator = "555555";
    };

    apps = {
      btop = ./btop.theme;

      ghostty.palette = [
        "0=#000000"
        "1=#aa0000"
        "2=#00aa00"
        "3=#aa5500"
        "4=#0000aa"
        "5=#aa00aa"
        "6=#00aaaa"
        "7=#aaaaaa"
        "8=#555555"
        "9=#ff5555"
        "10=#55ff55"
        "11=#ffff55"
        "12=#5555ff"
        "13=#ff55ff"
        "14=#55ffff"
        "15=#ffffff"
      ];

      voxtype = {
        meterLow = "55ff55";
        meterMid = "ffff55";
        meterHigh = "ff5555";
      };

      neovim = {
        plugin = nibbleRepo;

        setup = ''
          vim.cmd.colorscheme("nibble")
        '';
      };
    };
  };
}
