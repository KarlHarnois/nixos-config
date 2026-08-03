{
  writeShellApplication,
  freerdp,
  gawk,
}:

let
  # OpenH264 garbles the second chroma stream AVC444 sends, so decode through FFmpeg.
  freerdpDecodingThroughFfmpeg = freerdp.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [ "-DWITH_OPENH264=OFF" ];
  });
in

writeShellApplication {
  name = "mtgo";

  runtimeInputs = [
    freerdpDecodingThroughFfmpeg
    gawk
  ];

  text = builtins.readFile ./mtgo.sh;
}
