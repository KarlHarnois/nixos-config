{ pkgs, ... }:

let
  githubThemeRepo = {
    owner = "projekt0n";
    repo = "github-nvim-theme";
    rev = "c106c9472154d6b2c74b74565616b877ae8ed31d";
    hash = "sha256-/A4hkKTzjzeoR1SuwwklraAyI8oMkhxrwBBV9xb59PA=";
  };

  palette = {
    accent = "79c0ff";
    foreground = "f0f6fc";
    background = "000000";
    surface = "161616";
    surfaceLight = "2a2a2a";
    separator = "30363d";
    alert = "ff7b72";
  };

  githubStatus = {
    success = "3fb950";
    attention = "d29922";
    danger = "f85149";
    done = "d2a8ff";
  };

  githubCanvasSubtle = "161b22";

  wallpaper =
    pkgs.runCommand "github-wallpaper.png"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick -size 1x1 xc:'#${palette.background}' "$out"
      '';
in
{
  theme = {
    font = "IosevkaTerm Nerd Font Mono";

    fontPackage = pkgs.nerd-fonts.iosevka-term;

    sansFont = {
      family = "Iosevka Aile";
      package = pkgs.iosevka-bin.override { variant = "Aile"; };
    };

    animations = false;

    showBarBorder = false;

    inherit wallpaper;

    inherit palette;

    apps = {
      btop = ./btop.theme;

      gtk = {
        inherit (palette) accent;
        accentForeground = palette.background;
      };

      ghostty.palette = [
        "0=#484f58"
        "1=#ff7b72"
        "2=#3fb950"
        "3=#d29922"
        "4=#58a6ff"
        "5=#bc8cff"
        "6=#39c5cf"
        "7=#b1bac4"
        "8=#6e7681"
        "9=#ffa198"
        "10=#56d364"
        "11=#e3b341"
        "12=#79c0ff"
        "13=#d2a8ff"
        "14=#56d4dd"
        "15=#ffffff"
      ];

      qutebrowser.selectedTab = palette.surface;

      ringleader = {
        inherit (githubStatus) success;
        warning = githubStatus.attention;
        merged = githubStatus.done;
      };

      voxtype = {
        meterLow = githubStatus.success;
        meterMid = githubStatus.attention;
        meterHigh = githubStatus.danger;
      };

      neovim = {
        plugin = githubThemeRepo;

        transparentBackground = true;

        setup = ''
          require("github-theme").setup({
            options = { transparent = true },
            groups = {
              all = {
                CursorLine = { bg = "#${githubCanvasSubtle}" },
              },
            },
          })
          vim.cmd.colorscheme("github_dark_default")
        '';
      };
    };
  };
}
