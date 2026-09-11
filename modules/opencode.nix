{ nixpkgs-unstable, ... }:

{
  nixpkgs.overlays = [
    (_final: prev: {
      opencode = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.opencode;
    })
  ];
}
