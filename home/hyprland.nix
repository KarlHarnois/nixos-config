{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  mod = "SUPER";
  terminal = "kitty";
  workspaceCount = 5;

  bind = keys: dispatcher: {
    _args = [ "${mod} + ${keys}" (mkLuaInline dispatcher) ];
  };

  vimDirections = { h = "left"; j = "down"; k = "up"; l = "right"; };

  focusBinds = lib.mapAttrsToList
    (key: direction: bind key ''hl.dsp.focus({ direction = "${direction}" })'')
    vimDirections;

  swapBinds = lib.mapAttrsToList
    (key: direction: bind "SHIFT + ${key}" ''hl.dsp.window.swap({ direction = "${direction}" })'')
    vimDirections;

  workspaceBinds = lib.concatMap
    (i:
      let workspace = toString i;
      in [
        (bind workspace "hl.dsp.focus({ workspace = ${workspace} })")
        (bind "SHIFT + ${workspace}" "hl.dsp.window.move({ workspace = ${workspace} })")
      ])
    (lib.range 1 workspaceCount);
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings = {
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      };

      config = {
        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "ctrl:nocaps";
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
        };

        decoration.rounding = 8;
      };

      bind = [
        (bind "Return" ''hl.dsp.exec_cmd("${terminal}")'')
        (bind "W" "hl.dsp.window.close()")
        (bind "F" "hl.dsp.window.fullscreen()")
        (bind "SHIFT + E" "hl.dsp.exit()")
      ] ++ focusBinds ++ swapBinds ++ workspaceBinds;
    };
  };
}
