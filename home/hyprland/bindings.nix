{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  mod = "SUPER";
  terminal = "ghostty";
  workspaceCount = 10;

  bind = keys: dispatcher: {
    _args = [ "${mod} + ${keys}" (mkLuaInline dispatcher) ];
  };

  launchOrFocus = {
    _var = mkLuaInline ''
      function(class, command)
        return function()
          local windows = hl.get_windows({ class = class })
          if #windows > 0 then
            hl.dispatch(hl.dsp.focus({ window = windows[1] }))
          else
            hl.exec_cmd(command)
          end
        end
      end'';
  };

  launchOrFocusTui = app: ''launchOrFocus("local.${app}", "${terminal} --class=local.${app} -e ${app}")'';

  vimDirections = { h = "left"; j = "down"; k = "up"; l = "right"; };

  focusBinds = lib.mapAttrsToList
    (key: direction: bind key ''hl.dsp.focus({ direction = "${direction}" })'')
    vimDirections;

  swapBinds = lib.mapAttrsToList
    (key: direction: bind "SHIFT + ${key}" ''hl.dsp.window.swap({ direction = "${direction}" })'')
    vimDirections;

  workspaceBinds = lib.concatMap
    (i:
      let
        workspace = toString i;
        key = toString (lib.mod i 10);
      in [
        (bind key "hl.dsp.focus({ workspace = ${workspace} })")
        (bind "SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${workspace} })")
      ])
    (lib.range 1 workspaceCount);
in
{
  wayland.windowManager.hyprland.settings = {
    inherit launchOrFocus;

    bind = [
      (bind "Return" ''hl.dsp.exec_cmd("${terminal}")'')
      (bind "W" "hl.dsp.window.close()")
      (bind "F" "hl.dsp.window.fullscreen()")
      (bind "SHIFT + E" "hl.dsp.exit()")
      (bind "N" ''hl.dsp.layout("togglesplit")'')
      (bind "SHIFT + M" (launchOrFocusTui "cliamp"))
      (bind "SHIFT + F" (launchOrFocusTui "yazi"))
      (bind "I" (launchOrFocusTui "impala"))
      (bind "U" (launchOrFocusTui "bluetui"))
      (bind "B" ''hl.dsp.exec_cmd("firefox -P personal")'')
      (bind "SHIFT + B" ''hl.dsp.exec_cmd("firefox -P work")'')
      (bind "C" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" })'')
      (bind "V" ''hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" })'')
      (bind "X" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "X" })'')
    ] ++ focusBinds ++ swapBinds ++ workspaceBinds;
  };
}
