# shellcheck shell=bash

base_margin_y=75
aspect_ratio_width=3
aspect_ratio_height=2

main() {
  make_active_window_floating
  local window_height window_width
  window_height=$(height_filling_screen)
  window_width=$((window_height * aspect_ratio_width / aspect_ratio_height))
  resize_and_center "$window_width" "$window_height"
}

make_active_window_floating() {
  hyprctl dispatch setfloating active
}

height_filling_screen() {
  local logical_height reserved_top vertical_margin
  read -r logical_height reserved_top < <(focused_monitor_geometry)
  vertical_margin=$((base_margin_y + reserved_top))
  printf '%s\n' "$((logical_height - 2 * vertical_margin))"
}

focused_monitor_geometry() {
  hyprctl monitors -j | jq -r '
    .[] | select(.focused)
    | "\((.height / .scale) | floor) \(.reserved[1])"
  '
}

resize_and_center() {
  hyprctl dispatch resizeactive exact "$1" "$2"
  hyprctl dispatch centerwindow
}

main
