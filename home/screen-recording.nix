{ pkgs, ... }:

let
  indicatorSignal = 8;

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
        record_while_indicating "$area" "$recording"
        notify-send "Screen recording saved" "$recording"
      }

      record_while_indicating() {
        wf-recorder --geometry "$1" --file "$2" &
        refresh_indicator
        wait
        refresh_indicator
      }

      refresh_indicator() {
        pkill -RTMIN+${toString indicatorSignal} -x waybar || true
      }

      main
    '';
  };

  recordingIndicatorStatus = pkgs.writeShellScript "screen-recording-indicator-status" ''
    if ${pkgs.procps}/bin/pgrep -x wf-recorder >/dev/null; then
      echo '{"text": "REC", "tooltip": "Stop recording", "class": "active"}'
    else
      echo '{"text": ""}'
    fi
  '';
in
{
  home.packages = [ toggleScreenRecording ];

  programs.waybar = {
    settings.mainBar."custom/screen-recording" = {
      exec = recordingIndicatorStatus;
      return-type = "json";
      signal = indicatorSignal;
      hide-empty-text = true;
      on-click = "toggle-screen-recording";
    };

    style = ''
      #custom-screen-recording {
        background-color: @accent;
        color: @background;
        padding: 0 4px;
        margin-right: 7px;
      }
    '';
  };
}
