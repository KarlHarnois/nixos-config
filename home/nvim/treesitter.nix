{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        endwise.enable = true;

        indent = {
          enable = true;
          # Treesitter's ruby indent queries are broken. Typing a period or an
          # opening brace reindents the line to the wrong column, so ruby falls
          # back to vim's regex indent.
          # https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
          # https://github.com/nvim-treesitter/nvim-treesitter/issues/6114
          disable = [ "ruby" ];
        };
      };
    };

    extraPlugins = [ pkgs.vimPlugins.nvim-treesitter-endwise ];
  };
}
