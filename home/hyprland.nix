{ lib, pkgs, ... }:

let
  inherit (lib.generators) mkLuaInline;

  mod = "SUPER";
  terminal = "kitty";
  workspaceCount = 5;
  cursorTheme = "Adwaita";
  cursorSize = 24;

  bind = keys: dispatcher: {
    _args = [ "${mod} + ${keys}" (mkLuaInline dispatcher) ];
  };

  bezierCurve = name: points: {
    _args = [ name { type = "bezier"; inherit points; } ];
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
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = cursorTheme;
    size = cursorSize;
    hyprcursor.enable = true;
  };

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

          col = {
            active_border = "rgb(8A8A8D)";
            inactive_border = "rgba(595959aa)";
          };
        };

        decoration = {
          rounding = 0;

          shadow = {
            enabled = true;
            range = 2;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 2;
            passes = 2;
            brightness = 0.60;
            contrast = 0.75;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        cursor = {
          hide_on_key_press = true;
          warp_on_change_workspace = 1;
        };
      };

      env = [
        { _args = [ "XCURSOR_THEME" cursorTheme ]; }
        { _args = [ "XCURSOR_SIZE" (toString cursorSize) ]; }
        { _args = [ "HYPRCURSOR_SIZE" (toString cursorSize) ]; }
      ];

      curve = [
        (bezierCurve "easeOutQuint" [ [ 0.23 1.0 ] [ 0.32 1.0 ] ])
        (bezierCurve "linear" [ [ 0.0 0.0 ] [ 1.0 1.0 ] ])
        (bezierCurve "almostLinear" [ [ 0.5 0.5 ] [ 0.75 1.0 ] ])
        (bezierCurve "quick" [ [ 0.15 0.0 ] [ 0.1 1.0 ] ])
      ];

      animation = [
        { leaf = "global"; enabled = true; speed = 10.0; bezier = "default"; }
        { leaf = "border"; enabled = true; speed = 5.39; bezier = "easeOutQuint"; }
        { leaf = "windows"; enabled = true; speed = 3.79; bezier = "easeOutQuint"; }
        { leaf = "windowsIn"; enabled = true; speed = 4.1; bezier = "easeOutQuint"; style = "popin 87%"; }
        { leaf = "windowsOut"; enabled = true; speed = 1.49; bezier = "linear"; style = "popin 87%"; }
        { leaf = "fadeIn"; enabled = true; speed = 1.73; bezier = "almostLinear"; }
        { leaf = "fadeOut"; enabled = true; speed = 1.46; bezier = "almostLinear"; }
        { leaf = "fade"; enabled = true; speed = 3.03; bezier = "quick"; }
        { leaf = "layers"; enabled = true; speed = 3.81; bezier = "easeOutQuint"; }
        { leaf = "layersIn"; enabled = true; speed = 4.0; bezier = "easeOutQuint"; style = "fade"; }
        { leaf = "layersOut"; enabled = true; speed = 1.5; bezier = "linear"; style = "fade"; }
        { leaf = "fadeLayersIn"; enabled = true; speed = 1.79; bezier = "almostLinear"; }
        { leaf = "fadeLayersOut"; enabled = true; speed = 1.39; bezier = "almostLinear"; }
        { leaf = "workspaces"; enabled = false; }
      ];

      bind = [
        (bind "Return" ''hl.dsp.exec_cmd("${terminal}")'')
        (bind "W" "hl.dsp.window.close()")
        (bind "F" "hl.dsp.window.fullscreen()")
        (bind "SHIFT + E" "hl.dsp.exit()")
      ] ++ focusBinds ++ swapBinds ++ workspaceBinds;
    };
  };
}
