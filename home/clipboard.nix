{ pkgs, theme, ... }:

let
  inherit (theme.palette)
    accent
    foreground
    surface
    separator
    ;

  # Unreleased upstream fix: skip copies flagged x-kde-passwordManagerHint
  dropSensitiveCopies = old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/savedra1/clipse/commit/cd197d0c99543782f5d5aaecf6d4af0c6150f271.patch";
        hash = "sha256-3PIspZqyihoZ3FAJxHsQkm9ysNYjoV1Dj5k83ENkyBM=";
      })
    ];
  };
in
{
  services.clipse = {
    enable = true;
    package = pkgs.clipse.overrideAttrs dropSensitiveCopies;

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

  services.wl-clip-persist = {
    enable = true;
    extraOptions = [
      "--all-mime-type-regex"
      "^(?!x-kde-passwordManagerHint).+"
    ];
  };
}
