readonly QUTEBROWSER_CLASS="org.qutebrowser.qutebrowser"
readonly HYPRLAND_EVENTS="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
readonly QUTEBROWSER_SOCKET_DIR="$XDG_RUNTIME_DIR/qutebrowser"
readonly FOCUS_COMMAND=":window-focus"
readonly BLUR_COMMAND=":window-blur"

last_sent_command=""

main() {
  socat -u "UNIX-CONNECT:$HYPRLAND_EVENTS" - | while read -r event; do
    handle_event "$event"
  done
}

handle_event() {
  local event="$1"
  [[ "$event" == activewindow\>\>* ]] || return 0
  local focused_class="${event#activewindow>>}"
  focused_class="${focused_class%%,*}"
  local command="$BLUR_COMMAND"
  [[ "$focused_class" == "$QUTEBROWSER_CLASS" ]] && command="$FOCUS_COMMAND"
  send_when_changed "$command"
}

send_when_changed() {
  local command="$1"
  [[ "$command" == "$last_sent_command" ]] && return 0
  last_sent_command="$command"
  send_to_qutebrowser "$command"
}

send_to_qutebrowser() {
  local command="$1"
  local socket
  for socket in "$QUTEBROWSER_SOCKET_DIR"/ipc-*; do
    [[ -S "$socket" ]] || continue
    printf '{"args": ["%s"], "target_arg": null, "protocol_version": 1}\n' "$command" \
      | socat - "UNIX-CONNECT:$socket" 2>/dev/null || true
  done
}

main
