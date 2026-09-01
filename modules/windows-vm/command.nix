{
  writeShellApplication,
  coreutils,
  freerdp,
  gawk,
  jq,
  passwordFile,
  storageDirectory,
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
    WINDOWS_VM_STORAGE_DIR = storageDirectory;
  };

  text = builtins.readFile ./windows-vm.sh;
}
