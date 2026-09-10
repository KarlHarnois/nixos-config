{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./toolbox.nix { })
    pkgs.python313
    pkgs.jq
  ];

  programs.uv = {
    enable = true;
    settings.python-preference = "only-system";
  };
}
