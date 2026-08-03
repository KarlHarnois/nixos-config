{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ./command.nix { }) ];
}
