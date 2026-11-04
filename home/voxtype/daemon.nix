{ pkgs, ... }:

{
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
