{
  writeShellApplication,
  coreutils,
  freerdp,
  gawk,
  jq,
  passwordFile,
  username,
}:

let
  # OpenH264 garbles the second chroma stream AVC444 sends, so decode through FFmpeg.
  freerdpDecodingThroughFfmpeg = freerdp.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [ "-DWITH_OPENH264=OFF" ];
  });
in

writeShellApplication {
  name = "windows-vm";

  runtimeInputs = [
    coreutils
    freerdpDecodingThroughFfmpeg
    gawk
    jq
  ];

  runtimeEnv = {
    WINDOWS_VM_USER = username;
    WINDOWS_VM_PASSWORD_FILE = passwordFile;
  };

  text = builtins.readFile ./windows-vm.sh;
}
