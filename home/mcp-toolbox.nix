{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcp-toolbox";
  version = "1.2.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/mcp-toolbox-for-databases/v${finalAttrs.version}/linux/amd64/toolbox";
    hash = "sha256-Yw+f1ZiBbQaWaN+BLCZoUMNHoqJepThOED5BPa2b+Eg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

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
})
