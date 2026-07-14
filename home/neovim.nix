{ pkgs, ... }:

let
  theme = import ./theme.nix;

  glyph = builtins.fromJSON;

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

    globals.mapleader = " ";

    plugins = {
      web-devicons.enable = true;

      neo-tree = {
        enable = true;

        settings = {
          log_to_file = false;

          filesystem = {
            bind_to_cwd = false;
            follow_current_file.enabled = true;
            use_libuv_file_watcher = true;
          };

          window.mappings = {
            l = "open";
            h = "close_node";
            "<space>" = "none";
          };

          default_component_configs = {
            indent = {
              with_expanders = true;
              expander_collapsed = glyph ''""'';
              expander_expanded = glyph ''""'';
              expander_highlight = "NeoTreeExpander";
            };

            git_status.symbols = {
              unstaged = glyph ''"󰄱"'';
              staged = glyph ''"󰱒"'';
            };
          };
        };
      };
    };

    opts = {
      laststatus = 0;
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
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }
      {
        mode = "n";
        key = "<leader>fe";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file tree";
      }
    ];
  };
}
