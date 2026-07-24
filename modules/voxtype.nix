{
  nixpkgs.overlays = [
    (final: prev: {
      voxtype-onnx = prev.voxtype-onnx.overrideAttrs (old: {
        cargoBuildFeatures = old.cargoBuildFeatures ++ [ "osd-gtk4" ];
        cargoCheckFeatures = old.cargoCheckFeatures ++ [ "osd-gtk4" ];

        nativeBuildInputs = old.nativeBuildInputs ++ [ final.wrapGAppsHook4 ];

        buildInputs = old.buildInputs ++ [
          final.gtk4
          final.gtk4-layer-shell
        ];

        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/voxtype --prefix PATH : $out/bin
        '';
      });
    })
  ];

  hardware.uinput.enable = true;

  users.users.karl.extraGroups = [ "uinput" ];
}
