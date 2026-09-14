{ unstablePackages, ... }:

{
  nixpkgs.overlays = [
    (_final: _prev: {
      inherit (unstablePackages) hyprland-preview-share-picker;
    })
  ];
}
