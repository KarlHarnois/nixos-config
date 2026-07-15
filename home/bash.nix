{ pkgs, ... }:

let
  nvimDefaultingToCurrentDir = ''
    n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }
  '';
in
{
  home.packages = [ pkgs.eza ];

  programs.bash = {
    enable = true;

    shellAliases = {
      ls = "eza -lh --group-directories-first --icons=auto";
      lsa = "ls -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";
      yz = "yazi";
    };

    initExtra = nvimDefaultingToCurrentDir;
  };
}
