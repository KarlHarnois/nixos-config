{ pkgs, ... }:

import ../ibm.nix {
  inherit pkgs;
  name = "cga";
  background = "0000aa";
  surface = "000000";
  frame = "5555ff";
  rampMid = "55ffff";
}
