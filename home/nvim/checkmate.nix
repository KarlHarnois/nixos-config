{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.checkmate-nvim ];

    extraConfigLua = builtins.readFile ./checkmate.lua;
  };
}
