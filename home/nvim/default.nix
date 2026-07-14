{ pkgs, ... }:

let
  theme = import ../theme.nix;

  trimTrailingWhitespaceOnSave = {
    event = "BufWritePre";
    pattern = "*";
    command = ''%s/\s\+$//e'';
  };

  reloadFileChangedOutside = {
    event = [ "FocusGained" "TermClose" "TermLeave" ];
    pattern = "*";
    command = "if &buftype !=# 'nofile' | checktime | endif";
  };

  colorschemePlugin = pkgs.vimUtils.buildVimPlugin {
    pname = theme.neovim.plugin.repo;
    version = builtins.substring 0 7 theme.neovim.plugin.rev;
    src = pkgs.fetchFromGitHub theme.neovim.plugin;
  };
in
{
  imports = [ ./neo-tree.nix ./snacks.nix ./telescope.nix ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    globals.mapleader = " ";

    opts = {
      laststatus = 0;
      number = true;
      relativenumber = false;
      cursorline = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      fillchars.eob = " ";
      signcolumn = "yes";
    };

    plugins.gitsigns.enable = true;

    extraPlugins = [ colorschemePlugin ];

    extraConfigLua = theme.neovim.setup;

    extraFiles."plugin/after/transparency.lua".source = ./transparency.lua;

    autoCmd = [ trimTrailingWhitespaceOnSave reloadFileChangedOutside ];

    keymaps = [
      { mode = "i"; key = "jj"; action = "<Esc>"; }
      { mode = "n"; key = "<cr>"; action = "o<Esc>"; }
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }
    ];
  };
}
