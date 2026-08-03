{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.checkmate-nvim ];

    extraConfigLua = ''
      require("checkmate").setup()
    '';
  };
}
