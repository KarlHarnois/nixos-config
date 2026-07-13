{
  font = "IosevkaTerm Nerd Font Mono";

  wallpaper = ./wallpaper.jpg;

  accent = "8a8a8d";
  foreground = "bebebe";
  background = "121212";
  surface = "1e1e1e";
  cursor = "eaeaea";
  selectionForeground = "eaeaea";
  selectionBackground = "333333";

  neovim = {
    plugin = {
      owner = "metalelf0";
      repo = "black-metal-theme-neovim";
      rev = "6d0207871387077f40d5396ab1ae90520e688d36";
      hash = "sha256-sRbXxekmQuL412AJKrSkI1EdcuYQkKm1qfcIyMNhLBA=";
    };

    setup = ''
      require("black-metal").setup({
        theme = "darkthrone",
        transparent = true,
      })
      require("black-metal").load()
    '';
  };

  colors = [
    "333333"
    "d35f5f"
    "ffc107"
    "b91c1c"
    "e68e0d"
    "d35f5f"
    "bebebe"
    "bebebe"
    "8a8a8d"
    "b91c1c"
    "ffc107"
    "b90a0a"
    "f59e0b"
    "b91c1c"
    "eaeaea"
    "ffffff"
  ];
}
