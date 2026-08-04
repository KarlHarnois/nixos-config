# shellcheck shell=bash
readonly CAMERA=${1:-$C920_DEFAULT_CAMERA}
readonly STATE_FILE=$C920_STATE_FILE
readonly TARGET_LUMINANCE=0.46
readonly TOLERANCE=0.04
readonly MIN_EXPOSURE=3
readonly MAX_EXPOSURE=333
readonly MAX_GAIN=255
readonly MAX_ITERATIONS=8
readonly PRESENCE_CONTRAST_THRESHOLD=0.25

exposure=250
gain=0

camera_is_busy() {
  fuser -s "$CAMERA" 2>/dev/null
}

load_state() {
  if [[ -f "$STATE_FILE" ]]; then
    read -r exposure gain < "$STATE_FILE"
  fi
}

save_state() {
  mkdir -p "$(dirname "$STATE_FILE")"
  echo "$exposure $gain" > "$STATE_FILE"
}

apply_fixed_controls() {
  v4l2-ctl --device "$CAMERA" \
    --set-ctrl auto_exposure=1 \
    --set-ctrl white_balance_automatic=0 \
    --set-ctrl focus_automatic_continuous=0
  v4l2-ctl --device "$CAMERA" \
    --set-ctrl exposure_dynamic_framerate=0 \
    --set-ctrl white_balance_temperature=5000 \
    --set-ctrl focus_absolute=0
}

apply_exposure_and_gain() {
  v4l2-ctl --device "$CAMERA" \
    --set-ctrl exposure_time_absolute="$exposure" \
    --set-ctrl gain="$gain"
}

measure_face_region() {
  local frame
  frame=$(mktemp --suffix=.jpg)
  ffmpeg -hide_banner -loglevel error -f v4l2 -video_size 1280x720 -i "$CAMERA" \
    -vf "select=gte(n\,5)" -frames:v 1 -y "$frame" >/dev/null 2>&1
  magick "$frame" -crop 400x400+440+160 -colorspace Gray \
    -format "%[fx:mean] %[fx:standard_deviation/mean]" info:
  rm -f "$frame"
}

nobody_in_frame() {
  awk -v cv="$1" -v threshold="$PRESENCE_CONTRAST_THRESHOLD" 'BEGIN { exit (cv < threshold) ? 0 : 1 }'
}

is_on_target() {
  awk -v m="$1" -v t="$TARGET_LUMINANCE" -v tol="$TOLERANCE" \
    'BEGIN { exit (m >= t - tol && m <= t + tol) ? 0 : 1 }'
}

scaled_exposure() {
  awk -v e="$exposure" -v m="$1" -v t="$TARGET_LUMINANCE" \
      -v lo="$MIN_EXPOSURE" -v hi="$MAX_EXPOSURE" \
    'BEGIN { e *= (t / m) ^ 1.8; if (e < lo) e = lo; if (e > hi) e = hi; printf "%d", e }'
}

stepped_gain() {
  awk -v g="$gain" -v m="$1" -v t="$TARGET_LUMINANCE" -v hi="$MAX_GAIN" \
    'BEGIN { g += (t - m) * 200; if (g < 0) g = 0; if (g > hi) g = hi; printf "%d", g }'
}

is_below_target() {
  awk -v m="$1" -v t="$TARGET_LUMINANCE" 'BEGIN { exit (m < t) ? 0 : 1 }'
}

should_adjust_gain() {
  if is_below_target "$1"; then
    [[ "$exposure" -ge "$MAX_EXPOSURE" ]]
  else
    [[ "$gain" -gt 0 ]]
  fi
}

adjust_towards_target() {
  local measured=$1
  if should_adjust_gain "$measured"; then
    gain=$(stepped_gain "$measured")
  else
    exposure=$(scaled_exposure "$measured")
  fi
}

tune() {
  local mean contrast
  for _ in $(seq "$MAX_ITERATIONS"); do
    apply_exposure_and_gain
    read -r mean contrast < <(measure_face_region)
    if nobody_in_frame "$contrast"; then
      return 1
    fi
    if is_on_target "$mean"; then
      return 0
    fi
    adjust_towards_target "$mean"
  done
}

restore_saved_values() {
  exposure=333
  gain=64
  load_state
  apply_exposure_and_gain
}

if camera_is_busy; then
  exit 0
fi

load_state
apply_fixed_controls

if tune; then
  save_state
else
  restore_saved_values
fi
