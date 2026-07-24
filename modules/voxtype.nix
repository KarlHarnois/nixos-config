{ nixpkgs-unstable, username, ... }:

{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
      in
      {
        voxtype-onnx = unstable.voxtype-onnx.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/osd/theme.rs \
              --replace-fail ".config/omarchy/current/theme" ".config/voxtype/theme"
          '';

          cargoBuildFeatures = old.cargoBuildFeatures ++ [ "osd-gtk4" ];
          cargoCheckFeatures = old.cargoCheckFeatures ++ [ "osd-gtk4" ];

          nativeBuildInputs = old.nativeBuildInputs ++ [ unstable.wrapGAppsHook4 ];

          buildInputs = old.buildInputs ++ [
            unstable.gtk4
            unstable.gtk4-layer-shell
          ];

          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/voxtype --prefix PATH : $out/bin:${final.playerctl}/bin
          '';
        });
      }
    )
  ];

  hardware.uinput.enable = true;

  users.users.${username}.extraGroups = [ "uinput" ];
}
