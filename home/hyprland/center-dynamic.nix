{
  pkgs,
  ...
}:

let
  centerDynamic = pkgs.writeShellApplication {
    name = "center-dynamic";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.jq
    ];
    text = builtins.readFile ./center-dynamic.sh;
  };
in
{
  home.packages = [ centerDynamic ];
}
