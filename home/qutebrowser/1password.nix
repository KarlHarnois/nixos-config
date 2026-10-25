{ lib, pkgs, ... }:

let
  fselMenu = pkgs.writeShellApplication {
    name = "fsel-menu";

    runtimeInputs = [ pkgs.fsel ];

    text = ''
      fsel --dmenu --only-match <"$1" >"$2"
    '';
  };

  passwordFill = pkgs.writeShellApplication {
    name = "1password-fill";

    runtimeInputs = [
      fselMenu
      pkgs.ghostty
      pkgs.jq
      pkgs.wl-clipboard
    ];

    runtimeEnv.FILL_SCRIPT = ./1password-fill.js;

    text = builtins.readFile ./1password-fill.sh;
  };
in
{
  programs.qutebrowser.keyBindings.normal.",p" = "spawn --userscript 1password-fill";

  xdg.configFile."qutebrowser/userscripts/1password-fill".source = lib.getExe passwordFill;
}
