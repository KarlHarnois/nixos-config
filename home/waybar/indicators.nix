let
  spaceMarker = "4px";
  spaceGroup = "14px";
in
{
  programs.waybar = {
    settings.mainBar."group/indicators" = {
      orientation = "inherit";
      modules = [
        "custom/voxtype"
        "custom/screen-recording"
      ];
    };

    style = ''
      box#indicators label {
        padding: 0 ${spaceMarker};
        background: @color_focus;
        color: @color_text_inverse;
      }

      box#indicators > * {
        margin-right: ${spaceMarker};
      }

      box#indicators > :last-child {
        margin-right: ${spaceGroup};
      }
    '';
  };
}
