{ ... }:

let
  nvimDefaultingToCurrentDir = ''
    n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }
  '';
in
{
  programs.bash = {
    enable = true;

    initExtra = nvimDefaultingToCurrentDir;
  };
}
