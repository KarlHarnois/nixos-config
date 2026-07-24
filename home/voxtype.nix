{ pkgs, theme, ... }:

let
  parakeetModelName = "parakeet-tdt-0.6b-v2";

  parakeetModelFile =
    upstreamName: hash:
    pkgs.fetchurl {
      url = "https://huggingface.co/istupakov/${parakeetModelName}-onnx/resolve/main/${upstreamName}";
      inherit hash;
    };

  parakeetModel = pkgs.linkFarm parakeetModelName {
    "config.json" =
      parakeetModelFile "config.json" "sha256-ZmkDx2uXmMrywhCv1PbNYLCKjb+YAOyNejvA0hSKxGY=";
    "decoder_joint-model.onnx" =
      parakeetModelFile "decoder_joint-model.int8.onnx" "sha256-pEn0ms1ol51BhlHdLctzfMDxvwIl4AninuMmNU7b99M=";
    "encoder-model.onnx" =
      parakeetModelFile "encoder-model.int8.onnx" "sha256-PgWB/aarhDiItR5W1+54ttW8MjfsETrx9zLR1ShqoVU=";
    "nemo128.onnx" =
      parakeetModelFile "nemo128.onnx" "sha256-qf3hSG6/zAjzKNda1GEMZ4Nf6ljHO6V+Mgmm9s8Bnp8=";
    "vocab.txt" = parakeetModelFile "vocab.txt" "sha256-7BgrcN1CETr/bFNyx1ysWMlSRD6yIyL1e71/U5d9SX0=";
  };
in
{
  home.packages = [ pkgs.voxtype-onnx ];

  home.file.".local/share/voxtype/models/${parakeetModelName}" = {
    source = parakeetModel;
    force = true;
  };

  xdg.configFile."voxtype/theme/colors.toml" = {
    force = true;
    text = ''
      background = "#${theme.palette.background}"
      foreground = "#${theme.palette.foreground}"
      accent = "#${theme.palette.accent}"
      color1 = "#${theme.apps.voxtype.meterHigh}"
      color2 = "#${theme.apps.voxtype.meterLow}"
      color3 = "#${theme.apps.voxtype.meterMid}"
    '';
  };

  xdg.configFile."voxtype/config.toml" = {
    force = true;
    text = ''
      engine = "parakeet"

      [hotkey]
      enabled = false

      [audio]
      device = "default"
      sample_rate = 16000
      max_duration_secs = 60
      pause_media = true

      [parakeet]
      model = "${parakeetModelName}"
      on_demand_loading = true

      [output]
      mode = "type"
      type_delay_ms = 1

      [output.notification]
      on_transcription = false
    '';
  };

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype push-to-talk voice-to-text daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.voxtype-onnx}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 5;

      # Without these, glibc arena caching retains ~650MB of freed model
      # memory after each transcription.
      Environment = [
        "MALLOC_ARENA_MAX=1"
        "MALLOC_TRIM_THRESHOLD_=65536"
        "MALLOC_MMAP_THRESHOLD_=65536"
      ];
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
