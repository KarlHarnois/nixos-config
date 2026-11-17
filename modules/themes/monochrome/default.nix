{
  lib,
  pkgs,
  designSystemPackage,
  ...
}:

let
  tokenTheme = "dark";

  glossary = builtins.fromJSON (builtins.readFile "${designSystemPackage}/glossary/glossary.json");

  colorEntries = builtins.filter (entry: entry.type == "color") glossary;

  tokenHex = builtins.listToAttrs (
    map (
      entry: lib.nameValuePair entry.id (lib.removePrefix "#" entry.values.${tokenTheme})
    ) colorEntries
  );

  base16Lines = lib.splitString "\n" (
    builtins.readFile "${designSystemPackage}/base16/${tokenTheme}.yaml"
  );

  base16Slot = line: builtins.match " *(base0[0-9A-F]): \"#([0-9a-f]{6})\"" line;

  base16 = builtins.listToAttrs (
    map (slot: lib.nameValuePair (builtins.elemAt slot 0) (builtins.elemAt slot 1)) (
      builtins.filter (slot: slot != null) (map base16Slot base16Lines)
    )
  );

  palette = {
    accent = tokenHex."color.focus";
    foreground = tokenHex."color.text.primary";
    background = tokenHex."color.surface.base";
    surface = tokenHex."color.surface.raised";
    surfaceLight = tokenHex."color.selection";
    separator = tokenHex."color.border.default";
    alert = tokenHex."color.focus";
  };

  ansiSlots = [
    "base00"
    "base08"
    "base0B"
    "base0A"
    "base0D"
    "base0E"
    "base0C"
    "base05"
    "base03"
    "base08"
    "base0B"
    "base0A"
    "base0D"
    "base0E"
    "base0C"
    "base07"
  ];

  ghosttyPalette = lib.imap0 (index: slot: "${toString index}=#${base16.${slot}}") ansiSlots;

  base16NvimRepo = {
    owner = "RRethy";
    repo = "base16-nvim";
    rev = "889f8cd25152e4a1d5dba7b15815a592d145d601";
    hash = "sha256-BWCWgqj9ZqBY4YLq2UnqRCuZJJLLPvB+t+Ix4USBO+c=";
  };

  base16LuaTable = lib.concatStringsSep ", " (
    lib.mapAttrsToList (slot: hex: "${slot} = \"#${hex}\"") base16
  );

  wallpaper =
    pkgs.runCommand "monochrome-wallpaper.png"
      {
        nativeBuildInputs = [ pkgs.imagemagick ];
      }
      ''
        magick -size 1x1 xc:'#${tokenHex."color.surface.sunken"}' "$out"
      '';

  btopTheme = pkgs.writeText "monochrome-btop.theme" ''
    theme[main_bg]="#${palette.background}"
    theme[main_fg]="#${tokenHex."color.text.primary"}"
    theme[title]="#${tokenHex."color.text.primary"}"
    theme[hi_fg]="#${tokenHex."color.focus"}"
    theme[selected_bg]="#${tokenHex."color.selection"}"
    theme[selected_fg]="#${tokenHex."color.text.primary"}"
    theme[inactive_fg]="#${tokenHex."color.gray.600"}"
    theme[graph_text]="#${tokenHex."color.text.secondary"}"
    theme[meter_bg]="#${tokenHex."color.selection"}"
    theme[proc_misc]="#${tokenHex."color.text.secondary"}"
    theme[cpu_box]="#${tokenHex."color.border.default"}"
    theme[mem_box]="#${tokenHex."color.border.default"}"
    theme[net_box]="#${tokenHex."color.border.default"}"
    theme[proc_box]="#${tokenHex."color.border.default"}"
    theme[div_line]="#${tokenHex."color.border.default"}"
    theme[temp_start]="#${tokenHex."color.gray.600"}"
    theme[temp_mid]="#${tokenHex."color.gray.400"}"
    theme[temp_end]="#${tokenHex."color.gray.50"}"
    theme[cpu_start]="#${tokenHex."color.gray.600"}"
    theme[cpu_mid]="#${tokenHex."color.gray.400"}"
    theme[cpu_end]="#${tokenHex."color.gray.50"}"
    theme[free_start]="#${tokenHex."color.gray.600"}"
    theme[free_mid]="#${tokenHex."color.gray.400"}"
    theme[free_end]="#${tokenHex."color.gray.50"}"
    theme[cached_start]="#${tokenHex."color.gray.600"}"
    theme[cached_mid]="#${tokenHex."color.gray.400"}"
    theme[cached_end]="#${tokenHex."color.gray.50"}"
    theme[available_start]="#${tokenHex."color.gray.600"}"
    theme[available_mid]="#${tokenHex."color.gray.400"}"
    theme[available_end]="#${tokenHex."color.gray.50"}"
    theme[used_start]="#${tokenHex."color.gray.600"}"
    theme[used_mid]="#${tokenHex."color.gray.400"}"
    theme[used_end]="#${tokenHex."color.gray.50"}"
    theme[download_start]="#${tokenHex."color.gray.600"}"
    theme[download_mid]="#${tokenHex."color.gray.400"}"
    theme[download_end]="#${tokenHex."color.gray.50"}"
    theme[upload_start]="#${tokenHex."color.gray.600"}"
    theme[upload_mid]="#${tokenHex."color.gray.400"}"
    theme[upload_end]="#${tokenHex."color.gray.50"}"
    theme[process_start]="#${tokenHex."color.gray.600"}"
    theme[process_mid]="#${tokenHex."color.gray.400"}"
    theme[process_end]="#${tokenHex."color.gray.50"}"
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

    animations = true;

    designSystemColors = true;

    inherit wallpaper palette;

    focusedBorder = tokenHex."color.border.focused";

    apps = {
      btop = btopTheme;

      gtk = {
        inherit (palette) accent;
        accentForeground = tokenHex."color.text.inverse";
      };

      ghostty.palette = ghosttyPalette;

      qutebrowser.selectedTab = palette.surface;

      ringleader = {
        success = base16.base0B;
        warning = base16.base0A;
        merged = base16.base0E;
      };

      voxtype = {
        meterLow = base16.base04;
        meterMid = base16.base05;
        meterHigh = base16.base07;
      };

      neovim = {
        plugin = base16NvimRepo;

        setup = ''
          require("base16-colorscheme").setup({ ${base16LuaTable} })
        '';
      };
    };
  };
}
