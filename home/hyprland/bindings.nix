{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  mod = "SUPER";
  terminal = "ghostty";
  workspaceCount = 10;

  bindKeys = keys: dispatcher: {
    _args = [
      keys
      (mkLuaInline dispatcher)
    ];
  };

  bind = keys: bindKeys "${mod} + ${keys}";

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

  launchOrFocusTui =
    app: ''launchOrFocus("local.${app}", "${terminal} --class=local.${app} -e ${app}")'';

  webappClass =
    url:
    let
      hostAndPath = lib.splitString "/" (lib.removePrefix "https://" url);
      host = lib.head hostAndPath;
      path = lib.concatStringsSep "_" (lib.tail hostAndPath);
    in
    "chrome-${host}__${path}-Default";

  launchOrFocusWebapp = url: ''launchOrFocus("${webappClass url}", "chromium --app=${url}")'';

  directionKeys = {
    h = "left";
    j = "down";
    k = "up";
    l = "right";
    Left = "left";
    Down = "down";
    Up = "up";
    Right = "right";
  };

  focusBinds = lib.mapAttrsToList (
    key: direction: bind key ''hl.dsp.focus({ direction = "${direction}" })''
  ) directionKeys;

  resizeStep = 100;

  resizeWindow =
    x: y: "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";

  resizeBinds = [
    (bind "minus" (resizeWindow (-resizeStep) 0))
    (bind "equal" (resizeWindow resizeStep 0))
    (bind "SHIFT + minus" (resizeWindow 0 (-resizeStep)))
    (bind "SHIFT + equal" (resizeWindow 0 resizeStep))
  ];

  swapBinds = lib.mapAttrsToList (
    key: direction: bind "SHIFT + ${key}" ''hl.dsp.window.swap({ direction = "${direction}" })''
  ) directionKeys;

  workspaceBinds = lib.concatMap (
    i:
    let
      workspace = toString i;
      key = toString (lib.mod i 10);
    in
    [
      (bind key "hl.dsp.focus({ workspace = ${workspace} })")
      (bind "SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${workspace} })")
    ]
  ) (lib.range 1 workspaceCount);
in
{
  wayland.windowManager.hyprland.settings = {
    inherit launchOrFocus;

    bind = [
      (bind "Return" ''hl.dsp.exec_cmd("${terminal}")'')
      (bind "Space" (launchOrFocusTui "fsel"))
      (bind "W" "hl.dsp.window.close()")
      (bind "F" "hl.dsp.window.fullscreen()")
      (bind "SHIFT + E" "hl.dsp.exit()")
      (bind "N" ''hl.dsp.layout("togglesplit")'')
      (bind "SHIFT + S" ''hl.dsp.layout("swapsplit")'')
      (bind "SHIFT + W" ''hl.dsp.workspace.move({ monitor = "+1" })'')
      (bind "SHIFT + M" (launchOrFocusTui "cliamp"))
      (bind "SHIFT + F" ''hl.dsp.exec_cmd("${terminal} -e yazi")'')
      (bind "I" (launchOrFocusTui "impala"))
      (bind "U" (launchOrFocusTui "bluetui"))
      (bind "T" (launchOrFocusTui "btop"))
      (bind "SHIFT + A" (launchOrFocusTui "wiremix"))
      (bind "CTRL + L" ''hl.dsp.exec_cmd("loginctl lock-session")'')
      (bind "SHIFT + D" (launchOrFocusWebapp "https://discord.com/app"))
      (bind "M" (launchOrFocusWebapp "https://www.messenger.com"))
      (bind "slash" ''launchOrFocus("1Password", "1password")'')
      (bind "B" ''hl.dsp.exec_cmd("firefox -P personal")'')
      (bind "SHIFT + B" ''hl.dsp.exec_cmd("firefox -P work")'')
      (bind "ALT + comma" (launchOrFocusTui "notification-history"))
      (bind "comma" ''hl.dsp.exec_cmd("makoctl dismiss")'')
      (bind "SHIFT + comma" ''hl.dsp.exec_cmd("makoctl dismiss --all")'')
      (bind "CTRL + comma" ''hl.dsp.exec_cmd("makoctl mode -t do-not-disturb")'')
      (bindKeys "Print" ''hl.dsp.exec_cmd("grimblast copysave area")'')
      (bindKeys "SHIFT + Print" ''hl.dsp.exec_cmd([[f="$XDG_RUNTIME_DIR/annotate.png"; grimblast save area "$f" && satty --filename "$f"]])'')
      (bind "C" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" })'')
      (bind "V" ''hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" })'')
      (bind "X" ''hl.dsp.send_shortcut({ mods = "CTRL", key = "X" })'')
    ]
    ++ focusBinds
    ++ swapBinds
    ++ resizeBinds
    ++ workspaceBinds;
  };
}
