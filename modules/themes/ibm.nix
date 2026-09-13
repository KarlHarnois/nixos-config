{
  pkgs,
  name,
  background,
  surface,
  frame,
  rampMid,
}:

let
  nibbleRepo = {
    owner = "cmoscofian";
    repo = "nibble-vim";
    rev = "7bc65491c4672aa389ab5c15209751f51af4f0b9";
    hash = "sha256-pAnR+3h1eqlxOAXLE9LYUVL08FtaWNI2s/HZI7Da7eU=";
  };

  palette = {
    accent = "55ffff";
    foreground = "ffffff";
    inherit background surface;
    surfaceLight = "5555ff";
    separator = "555555";
  };

  wallpaper =
    pkgs.runCommand "${name}-wallpaper.png"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick -size 1x1 xc:'#${background}' "$out"
      '';

  btopTheme = pkgs.writeText "${name}-btop.theme" ''
    theme[main_bg]="#${background}"
    theme[main_fg]="#aaaaaa"
    theme[title]="#aaaaaa"
    theme[hi_fg]="#55ffff"
    theme[selected_bg]="#${frame}"
    theme[selected_fg]="#ffffff"
    theme[inactive_fg]="#555555"
    theme[graph_text]="#aaaaaa"
    theme[meter_bg]="#${frame}"
    theme[proc_misc]="#55ffff"
    theme[cpu_box]="#${frame}"
    theme[mem_box]="#${frame}"
    theme[net_box]="#${frame}"
    theme[proc_box]="#${frame}"
    theme[div_line]="#${frame}"
    theme[temp_start]="#55ff55"
    theme[temp_mid]="#ffff55"
    theme[temp_end]="#ff5555"
    theme[cpu_start]="#55ff55"
    theme[cpu_mid]="#ffff55"
    theme[cpu_end]="#ff5555"
    theme[free_start]="#${frame}"
    theme[free_mid]="#${rampMid}"
    theme[free_end]="#aaaaaa"
    theme[cached_start]="#${frame}"
    theme[cached_mid]="#${rampMid}"
    theme[cached_end]="#aaaaaa"
    theme[available_start]="#${frame}"
    theme[available_mid]="#${rampMid}"
    theme[available_end]="#aaaaaa"
    theme[used_start]="#${frame}"
    theme[used_mid]="#${rampMid}"
    theme[used_end]="#ffffff"
    theme[download_start]="#55ff55"
    theme[download_mid]="#ffff55"
    theme[download_end]="#ff5555"
    theme[upload_start]="#55ff55"
    theme[upload_mid]="#ffff55"
    theme[upload_end]="#ff5555"
    theme[process_start]="#55ff55"
    theme[process_mid]="#ffff55"
    theme[process_end]="#ff5555"
    theme[followed_bg]="#${frame}"
    theme[followed_fg]="#ffffff"
    theme[proc_banner_bg]="#${frame}"
    theme[proc_banner_fg]="#ffffff"
    theme[proc_follow_bg]="#${frame}"
    theme[proc_pause_bg]="#aa0000"
  '';
in
{
  theme = {
    font = "BigBlueTerm437 Nerd Font Mono";

    fontPackage = pkgs.nerd-fonts.bigblue-terminal;

    transparency = false;

    animations = false;

    inherit wallpaper;

    inherit palette;

    apps = {
      btop = btopTheme;

      ghostty = {
        lineHeightPercent = 133;

        palette = [
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
      };

      voxtype = {
        meterLow = "55ff55";
        meterMid = "ffff55";
        meterHigh = "ff5555";
      };

      neovim = {
        plugin = nibbleRepo;

        setup = ''
          vim.cmd.colorscheme("nibble")

          for _, group in ipairs({ "Normal", "NormalFloat", "NormalNC" }) do
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            hl.bg = "#${palette.background}"
            vim.api.nvim_set_hl(0, group, hl)
          end
        '';
      };
    };
  };
}
