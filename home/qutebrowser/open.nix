let
  newTabOpenPrompt = "cmd-set-text -s :open -t";
in
{
  programs.qutebrowser.keyBindings.normal = {
    O = newTabOpenPrompt;
    "<Ctrl-o>" = newTabOpenPrompt;
  };
}
