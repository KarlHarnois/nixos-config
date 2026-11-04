{
  lib,
  osConfig,
  pkgs,
  unstablePackages,
  ...
}:

let
  inherit (osConfig) theme;

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

  s1MiniModel = pkgs.fetchurl {
    url = "https://huggingface.co/superwhisper/s1-mini-GGUF/resolve/main/s1-mini-q4_k_m.gguf";
    hash = "sha256-O0Hr4lAsvQPoEdXRawIvWrVR7aWNYll9FS+JU1ADxjQ=";
  };

  s1MiniMappedModelMegabytes = 490;
  cleanupServerWorkingMegabytes = 300;

  cleanupServerAddress = "127.0.0.1";
  cleanupServerPort = 18080;
  cleanupServerUrl = "http://${cleanupServerAddress}:${toString cleanupServerPort}";
  cleanupTimeoutSeconds = "6";

  s1MiniSystemPrompt = "You are a text normalizer for speech-to-text transcripts. The input begins with a control line specifying the styling, structure, and context settings; clean the transcript to match those settings and output only the cleaned text.";
  s1MiniControlLine = "[Styling: semi-formal] [Structure: prose] [Context: general]";

  cleanDictation = pkgs.writeShellApplication {
    name = "voxtype-clean-dictation";
    runtimeInputs = [
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      clean_with_s1_mini() {
        s1_mini_request "$(cat)" |
          curl --silent --fail --max-time ${cleanupTimeoutSeconds} \
            --header 'Content-Type: application/json' --data @- ${cleanupServerUrl}/v1/chat/completions |
          jq --raw-output --exit-status '.choices[0].message.content'
      }

      s1_mini_request() {
        jq --null-input \
          --arg system ${lib.escapeShellArg s1MiniSystemPrompt} \
          --arg user ${lib.escapeShellArg s1MiniControlLine}$'\n'"$1" \
          '{messages: [{role: "system", content: $system}, {role: "user", content: $user}], temperature: 0}'
      }

      clean_with_s1_mini
    '';
  };

  cleanupServer = lib.escapeShellArgs [
    "${unstablePackages.llama-cpp-vulkan}/bin/llama-server"
    "--model"
    s1MiniModel
    "--host"
    cleanupServerAddress
    "--port"
    (toString cleanupServerPort)
    "--jinja"
    "--chat-template-kwargs"
    (builtins.toJSON { enable_thinking = false; })
    "--temp"
    "0"
    "--ctx-size"
    "512"
    "--batch-size"
    "256"
    "--ubatch-size"
    "256"
    "--parallel"
    "1"
    "--no-repack"
    "--no-webui"
    "--log-disable"
  ];
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
      background = "${theme.palette.background.hex}"
      foreground = "${theme.palette.foreground.hex}"
      accent = "${theme.palette.accent.hex}"
      color1 = "${theme.apps.voxtype.meterHigh.hex}"
      color2 = "${theme.apps.voxtype.meterLow.hex}"
      color3 = "${theme.apps.voxtype.meterMid.hex}"
    '';
  };

  xdg.configFile."voxtype/config.toml" = {
    force = true;
    text = ''
      engine = "parakeet"

      [hotkey]
      enabled = true
      key = "F1"
      modifiers = []

      [audio]
      device = "default"
      sample_rate = 16000
      max_duration_secs = 60
      pause_media = true

      [parakeet]
      model = "${parakeetModelName}"
      on_demand_loading = true

      [output]
      # Paste instead of type: wtype puts the 15th distinct character on the Tab key code,
      # and Ghostty sends it as a Tab (atx/wtype#71).
      mode = "paste"
      paste_keys = "ctrl+shift+v"
      restore_clipboard = true
      wait_for_modifier_release = false

      [output.post_process]
      command = "${cleanDictation}/bin/voxtype-clean-dictation"
      timeout_ms = 8000

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

  systemd.user.services.voxtype-cleanup = {
    Unit = {
      Description = "S1-mini dictation cleanup server for Voxtype";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Before = [ "voxtype.service" ];
    };

    Service = {
      ExecStart = cleanupServer;
      Restart = "on-failure";
      RestartSec = 5;

      MemoryHigh = "${toString (s1MiniMappedModelMegabytes + cleanupServerWorkingMegabytes)}M";
      MemoryMax = "${toString (s1MiniMappedModelMegabytes + cleanupServerWorkingMegabytes * 2)}M";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
