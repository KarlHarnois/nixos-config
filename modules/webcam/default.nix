{ pkgs, username, ... }:

let
  defaultCamera = "/dev/v4l/by-id/usb-046d_HD_Pro_Webcam_C920_DA4B235F-video-index0";
  stateFile = "/home/${username}/.local/state/c920/controls";

  c920-apply = pkgs.writeShellApplication {
    name = "c920-apply";
    runtimeInputs = [ pkgs.v4l-utils ];
    runtimeEnv.C920_STATE_FILE = stateFile;
    text = builtins.readFile ./c920-apply.sh;
  };

  c920-tune = pkgs.writeShellApplication {
    name = "c920-tune";
    runtimeInputs = [
      pkgs.v4l-utils
      pkgs.ffmpeg
      pkgs.imagemagick
      pkgs.psmisc
      pkgs.gawk
      pkgs.coreutils
    ];
    runtimeEnv = {
      C920_STATE_FILE = stateFile;
      C920_DEFAULT_CAMERA = defaultCamera;
    };
    text = builtins.readFile ./c920-tune.sh;
  };
in
{
  environment.systemPackages = [
    c920-apply
    c920-tune
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="video4linux", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="082d", ATTR{index}=="0", RUN+="${c920-apply}/bin/c920-apply $devnode"
  '';
}
