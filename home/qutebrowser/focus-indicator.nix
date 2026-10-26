{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  colors = config.programs.qutebrowser.settings.colors;
  fadedText = osConfig.theme.palette.separator.hex;
  unselectedTabBackground = colors.tabs.odd.bg;

  textOptions = [
    "tabs.odd.fg"
    "tabs.even.fg"
    "tabs.selected.odd.fg"
    "tabs.selected.even.fg"
    "statusbar.normal.fg"
    "statusbar.url.fg"
    "statusbar.url.success.http.fg"
    "statusbar.url.success.https.fg"
  ];

  selectedTabBackgroundOptions = [
    "tabs.selected.odd.bg"
    "tabs.selected.even.bg"
  ];

  configuredColor = option: lib.getAttrFromPath (lib.splitString "." option) colors;

  setTemporarily =
    colorOf: options:
    lib.concatMapStringsSep " ;; " (option: "set --temp colors.${option} ${colorOf option}") options;

  focusedColors = setTemporarily configuredColor (textOptions ++ selectedTabBackgroundOptions);

  fadedColors = lib.concatStringsSep " ;; " [
    (setTemporarily (_: fadedText) textOptions)
    (setTemporarily (_: unselectedTabBackground) selectedTabBackgroundOptions)
  ];

  focusIndicator = pkgs.writeShellApplication {
    name = "qutebrowser-focus-indicator";
    runtimeInputs = [ pkgs.socat ];
    text = builtins.readFile ./focus-indicator.sh;
  };
in
{
  programs.qutebrowser = {
    aliases = {
      window-focus = focusedColors;
      window-blur = fadedColors;
    };

    # IPC commands raise and focus the window unless it opens new instances silently,
    # which would pull focus back every time window-blur is sent.
    settings.new_instance_open_target = "tab-silent";
  };

  systemd.user.services.qutebrowser-focus-indicator = {
    Unit = {
      Description = "Fade qutebrowser's tabs and status bar when it loses focus";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = lib.getExe focusIndicator;
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
