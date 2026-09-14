{
  lib,
  unstablePackages,
  username,
  ...
}:

{
  nixpkgs.overlays = [
    (
      final: _prev:
      let
        readThemeFromVoxtypeConfig = old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/osd/theme.rs \
              --replace-fail ".config/omarchy/current/theme" ".config/voxtype/theme"
          '';
        };

        enableRecordingOsd = old: {
          cargoBuildFeatures = old.cargoBuildFeatures ++ [ "osd-gtk4" ];
          cargoCheckFeatures = old.cargoCheckFeatures ++ [ "osd-gtk4" ];
          nativeBuildInputs = old.nativeBuildInputs ++ [ unstablePackages.wrapGAppsHook4 ];
          buildInputs = old.buildInputs ++ [
            unstablePackages.gtk4
            unstablePackages.gtk4-layer-shell
          ];
        };

        putPlayerctlOnPath = old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/voxtype --prefix PATH : $out/bin:${final.playerctl}/bin
          '';
        };
      in
      {
        voxtype-onnx = lib.foldl (pkg: override: pkg.overrideAttrs override) unstablePackages.voxtype-onnx [
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
