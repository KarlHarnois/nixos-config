{
  lib,
  pkgs,
  unstablePackages,
  ...
}:

let
  cleanupEndpoint = import ./cleanup-endpoint.nix;

  s1MiniModel = pkgs.fetchurl {
    url = "https://huggingface.co/superwhisper/s1-mini-GGUF/resolve/main/s1-mini-q4_k_m.gguf";
    hash = "sha256-O0Hr4lAsvQPoEdXRawIvWrVR7aWNYll9FS+JU1ADxjQ=";
  };

  s1MiniMappedModelMegabytes = 490;
  cleanupServerWorkingMegabytes = 300;

  cleanupServer = lib.escapeShellArgs [
    "${unstablePackages.llama-cpp-vulkan}/bin/llama-server"
    "--model"
    s1MiniModel
    "--host"
    cleanupEndpoint.address
    "--port"
    (toString cleanupEndpoint.port)
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
