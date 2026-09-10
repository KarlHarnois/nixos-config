{ pkgs, ... }:

{
  home.packages = [ pkgs.opencode ];

  programs.bash.shellAliases = {
    oc = "opencode";
    ocr = "opencode run";
  };
}
