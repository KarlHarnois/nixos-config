{
  lib,
  nixpkgs-unstable,
  username,
  ...
}:

{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};

        readThemeFromVoxtypeConfig = old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/osd/theme.rs \
              --replace-fail ".config/omarchy/current/theme" ".config/voxtype/theme"
          '';
        };

        enableRecordingOsd = old: {
          cargoBuildFeatures = old.cargoBuildFeatures ++ [ "osd-gtk4" ];
          cargoCheckFeatures = old.cargoCheckFeatures ++ [ "osd-gtk4" ];
          nativeBuildInputs = old.nativeBuildInputs ++ [ unstable.wrapGAppsHook4 ];
          buildInputs = old.buildInputs ++ [
            unstable.gtk4
            unstable.gtk4-layer-shell
          ];
        };

        putPlayerctlOnPath = old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/voxtype --prefix PATH : $out/bin:${final.playerctl}/bin
          '';
        };
      in
      {
        voxtype-onnx = lib.foldl (pkg: override: pkg.overrideAttrs override) unstable.voxtype-onnx [
          readThemeFromVoxtypeConfig
          enableRecordingOsd
          putPlayerctlOnPath
        ];
      }
    )
  ];

  hardware.uinput.enable = true;

  users.users.${username}.extraGroups = [ "uinput" ];
}
