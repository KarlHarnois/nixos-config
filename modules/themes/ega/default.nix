{ pkgs, ... }:

import ../ibm.nix {
  inherit pkgs;
  name = "ega";
  background = "000000";
  surface = "0000aa";
  frame = "0000aa";
  rampMid = "5555ff";
}
