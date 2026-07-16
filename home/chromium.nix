{ ... }:

let
  vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
in
{
  programs.chromium = {
    enable = true;
    extensions = [ { id = vimium; } ];
  };
}
