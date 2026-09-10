{ pkgs, lib, ... }:

let
  mcpToolbox = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "mcp-toolbox";
    version = "1.2.0";

    src = pkgs.fetchurl {
      url = "https://storage.googleapis.com/mcp-toolbox-for-databases/v${finalAttrs.version}/linux/amd64/toolbox";
      hash = "sha256-Yw+f1ZiBbQaWaN+BLCZoUMNHoqJepThOED5BPa2b+Eg=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/toolbox
      runHook postInstall
    '';

    meta = {
      mainProgram = "toolbox";
      platforms = [ "x86_64-linux" ];
      license = lib.licenses.asl20;
    };
  });
in
{
  home.packages = [
    mcpToolbox
    pkgs.python313
    pkgs.jq
  ];

  programs.uv = {
    enable = true;
    settings.python-preference = "only-system";
  };
}
