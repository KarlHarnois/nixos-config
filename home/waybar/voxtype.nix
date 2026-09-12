{ lib, pkgs, ... }:

let
  voxtypeStatusStream = pkgs.writeShellScript "voxtype-status-stream" ''
    trap 'kill 0' EXIT
    ${pkgs.voxtype-onnx}/bin/voxtype status --follow --extended --format json \
      | ${lib.getExe pkgs.jq} --unbuffered --compact-output '. + {alt: .class}'
  '';
in
{
  programs.waybar = {
    settings.mainBar."custom/voxtype" = {
      exec = voxtypeStatusStream;
      return-type = "json";
      format = "{icon}";

      format-icons = {
        idle = "";
        recording = "󰍬";
        transcribing = "󰔟";
      };
    };

    style = ''
      #custom-voxtype {
        min-width: 12px;
      }
    '';
  };
}
