# shellcheck shell=bash
camera=$1

exposure=333
gain=64
if [[ -f "$C920_STATE_FILE" ]]; then
  read -r exposure gain < "$C920_STATE_FILE"
fi

v4l2-ctl --device "$camera" \
  --set-ctrl auto_exposure=1 \
  --set-ctrl white_balance_automatic=0 \
  --set-ctrl focus_automatic_continuous=0

v4l2-ctl --device "$camera" \
  --set-ctrl exposure_dynamic_framerate=0 \
  --set-ctrl exposure_time_absolute="$exposure" \
  --set-ctrl gain="$gain" \
  --set-ctrl white_balance_temperature=5000 \
  --set-ctrl focus_absolute=0
