{ lib, ... }:

let
  mkColor = lib.mkOption {
    type = lib.types.strMatching "[0-9a-f]{6}";
    description = "A 6-character lowercase hex color without a leading `#`.";
    apply = hex: {
      hex = "#${hex}";
      rgb = "rgb(${hex})";
      rgba = alpha: "rgba(${hex}${alpha})";
      hexAlpha = alpha: "#${hex}${alpha}";
    };
  };

  repoType = lib.types.submodule {
    options = {
      owner = lib.mkOption { type = lib.types.str; };
      repo = lib.mkOption { type = lib.types.str; };
      rev = lib.mkOption { type = lib.types.str; };
      hash = lib.mkOption { type = lib.types.str; };
    };
  };

  paletteType = lib.types.submodule {
    options = {
      accent = mkColor;
      foreground = mkColor;
      background = mkColor;
      surface = mkColor;
      surfaceLight = mkColor;
      separator = mkColor;
    };
  };

  appsType = lib.types.submodule {
    options = {
      btop = lib.mkOption {
        type = lib.types.path;
        description = "btop color theme file.";
      };

      ghostty = lib.mkOption {
        type = lib.types.submodule {
          options = {
            repo = lib.mkOption {
              type = repoType;
              description = "Repository hosting the Ghostty theme.";
            };
            themeFile = lib.mkOption {
              type = lib.types.str;
              description = "Path of the theme file within the repository.";
            };
            palette = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "ANSI palette overrides in Ghostty `N=COLOR` form, applied on top of the theme file.";
            };
          };
        };
      };

      voxtype = lib.mkOption {
        type = lib.types.submodule {
          options = {
            meterLow = mkColor;
            meterMid = mkColor;
            meterHigh = mkColor;
          };
        };
      };

      neovim = lib.mkOption {
        type = lib.types.submodule {
          options = {
            plugin = lib.mkOption {
              type = repoType;
              description = "Repository hosting the colorscheme plugin.";
            };
            setup = lib.mkOption {
              type = lib.types.lines;
              description = "Lua configuring and loading the colorscheme.";
            };
          };
        };
      };
    };
  };
in
{
  options.theme = {
    font = lib.mkOption {
      type = lib.types.str;
      description = "Font family used throughout the desktop.";
    };

    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper image.";
    };

    palette = lib.mkOption {
      type = paletteType;
      description = "Colors shared across themed applications.";
    };

    apps = lib.mkOption {
      type = appsType;
      description = "Per-application theme data.";
    };
  };
}
