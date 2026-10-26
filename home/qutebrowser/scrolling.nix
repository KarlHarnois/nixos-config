let
  halfPageDown = "scroll-page 0 0.5";
  halfPageUp = "scroll-page 0 -0.5";
in
{
  programs.qutebrowser.keyBindings.normal = {
    d = halfPageDown;
    u = halfPageUp;
  };
}
