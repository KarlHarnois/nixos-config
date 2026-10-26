{ lib, ... }:

let
  defaultKeysStartingWithT = [
    "th"
    "tl"
    "tsh"
    "tsH"
    "tsu"
    "tSh"
    "tSH"
    "tSu"
    "tph"
    "tpH"
    "tpu"
    "tPh"
    "tPH"
    "tPu"
    "tih"
    "tiH"
    "tiu"
    "tIh"
    "tIH"
    "tIu"
    "tch"
    "tcH"
    "tcu"
    "tCh"
    "tCH"
    "tCu"
  ];

  unbound = lib.genAttrs defaultKeysStartingWithT (_: null);
in
{
  programs.qutebrowser = {
    quickmarks = {
      gh = "https://github.com/KarlHarnois";
      sf = "https://scryfall.com/";
      gm = "https://mail.google.com/mail/u/0/#inbox";
      cl = "https://calendar.google.com/calendar/u/0/r/day?pli=1";
      yt = "https://www.youtube.com/";
    };

    keyBindings.normal = unbound // {
      t = "cmd-set-text -s :quickmark-load";
      "<Ctrl-t>" = "cmd-set-text -s :quickmark-load -t";
    };
  };
}
