ACTIONS=(
  "loginctl lock-session:Lock"
  "systemctl suspend:Suspend"
  "hyprctl dispatch exit:Log out"
  "systemctl reboot:Reboot"
  "systemctl poweroff:Power off"
)

selection="$(printf '%s\n' "${ACTIONS[@]}" | fzf \
  --delimiter=: \
  --with-nth=-1 \
  --accept-nth=1 \
  --header=Session \
  --layout=reverse \
  --no-info \
  --cycle)"

read -ra action <<<"$selection"
"${action[@]}"
