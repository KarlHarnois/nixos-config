{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ./toolbox.nix { }) ];
}
