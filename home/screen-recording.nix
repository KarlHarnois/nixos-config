{ pkgs, ... }:

let
  toggleScreenRecording = pkgs.writeShellApplication {
    name = "toggle-screen-recording";
    runtimeInputs = [
      pkgs.libnotify
      pkgs.procps
      pkgs.slurp
      pkgs.wf-recorder
    ];
    text = ''
      readonly RECORDINGS_DIR="$HOME/Videos"

      main() {
        if recording_in_progress; then
          stop_recording
        else
          start_recording
        fi
      }

      recording_in_progress() {
        pgrep -x wf-recorder >/dev/null
      }

      stop_recording() {
        pkill -INT -x wf-recorder
      }

      start_recording() {
        local area recording
        area=$(slurp)
        recording="$RECORDINGS_DIR/screenrecording-$(date +%Y-%m-%d_%H-%M-%S).mp4"
        mkdir -p "$RECORDINGS_DIR"
        notify-send "Screen recording started"
        wf-recorder --geometry "$area" --file "$recording"
        notify-send "Screen recording saved" "$recording"
      }

      main
    '';
  };
in
{
  home.packages = [ toggleScreenRecording ];
}
