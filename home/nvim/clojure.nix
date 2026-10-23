{ pkgs, ... }:

{
  programs.nixvim = {
    extraPackages = with pkgs; [
      clojure
      clojure-lsp
      jdk
    ];

    extraPlugins = with pkgs.vimPlugins; [
      nvim-parinfer
      nvim-paredit
      parpar-nvim
    ];

    plugins.conjure.enable = true;

    plugins.lsp.servers.clojure_lsp.enable = true;

    extraConfigLua = ''
      require("parpar").setup({
        paredit = {
          indent = { enabled = true },
        },
      })
    '';
  };
}
