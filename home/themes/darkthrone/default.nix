let
  blackMetalRepo = {
    owner = "metalelf0";
    repo = "black-metal-theme-neovim";
    rev = "6d0207871387077f40d5396ab1ae90520e688d36";
    hash = "sha256-sRbXxekmQuL412AJKrSkI1EdcuYQkKm1qfcIyMNhLBA=";
  };
in
{
  font = "IosevkaTerm Nerd Font Mono";

  wallpaper = ./wallpaper.jpg;

  palette = {
    accent = "8a8a8d";
    foreground = "c1c1c1";
    background = "121212";
    surface = "1e1e1e";
    surfaceLight = "333333";
    separator = "505050";
  };

  apps = {
    btop = ./btop.theme;

    ghostty = {
      repo = blackMetalRepo;
      themeFile = "extras/ghostty/darkthrone.lua";
    };

    voxtype = {
      meterLow = "c1c1c1";
      meterMid = "888888";
      meterHigh = "5f8787";
    };

    neovim = {
      plugin = blackMetalRepo;

      setup = ''
        require("black-metal").setup({
          theme = "darkthrone",
          transparent = true,
        })
        require("black-metal").load()
      '';
    };
  };
}
