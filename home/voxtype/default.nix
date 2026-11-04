{ pkgs, ... }:

let
  parakeetModel = pkgs.callPackage ./parakeet-model.nix { };
  cleanDictation = pkgs.callPackage ./clean-dictation.nix { };
in
{
  imports = [
    ./cleanup-server.nix
    ./daemon.nix
    ./theme.nix
  ];

  home.packages = [ pkgs.voxtype-onnx ];

  home.file.".local/share/voxtype/models/${parakeetModel.name}" = {
    source = parakeetModel;
    force = true;
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
      model = "${parakeetModel.name}"
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
}
