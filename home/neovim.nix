{ pkgs, ... }:

let
  theme = import ./theme.nix;

  trimTrailingWhitespaceOnSave = {
    event = "BufWritePre";
    pattern = "*";
    command = ''%s/\s\+$//e'';
  };

  colorschemePlugin = pkgs.vimUtils.buildVimPlugin {
    pname = theme.neovim.plugin.repo;
    version = builtins.substring 0 7 theme.neovim.plugin.rev;
    src = pkgs.fetchFromGitHub theme.neovim.plugin;
  };
in
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = false;
      cursorline = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
    };

    extraPlugins = [ colorschemePlugin ];
    extraConfigLua = theme.neovim.setup;

    autoCmd = [ trimTrailingWhitespaceOnSave ];

    keymaps = [
      { mode = "i"; key = "jj"; action = "<Esc>"; }
      { mode = "n"; key = "<cr>"; action = "o<Esc>"; }
    ];
  };
}
