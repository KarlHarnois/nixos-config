{ theme, ... }:

let
  inherit (theme.palette)
    accent
    foreground
    surface
    separator
    ;
in
{
  services.clipse = {
    enable = true;

    imageDisplay.type = "kitty";

    theme = {
      useCustomTheme = true;
      NormalTitle = foreground.hex;
      NormalDesc = separator.hex;
      DimmedTitle = separator.hex;
      DimmedDesc = separator.hex;
      FilteredMatch = accent.hex;
      SelectedTitle = accent.hex;
      SelectedDesc = foreground.hex;
      SelectedBorder = accent.hex;
      SelectedDescBorder = accent.hex;
      TitleFore = accent.hex;
      Titleback = surface.hex;
      StatusMsg = accent.hex;
      PinIndicatorColor = accent.hex;
    };
  };

  services.wl-clip-persist.enable = true;
}
