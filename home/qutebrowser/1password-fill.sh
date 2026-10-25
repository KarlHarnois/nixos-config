main() {
  trap 'send_to_qutebrowser "message-error \"1password-fill failed, is 1Password unlocked?\""' ERR
  local account item_id
  read -r account item_id <<<"$(pick_item "$(candidate_items)")"
  [[ -n $item_id ]] || exit 0
  fill_login "$account" "$item_id"
  copy_totp "$account" "$item_id"
}

send_to_qutebrowser() {
  echo "$1" >>"$QUTE_FIFO"
}

candidate_items() {
  local all_logins site_logins
  all_logins=$(logins_from_all_accounts)
  site_logins=$(logins_for_site "$(site_host)" <<<"$all_logins")
  if [[ $(jq length <<<"$site_logins") == 0 ]]; then
    echo "$all_logins"
  else
    echo "$site_logins"
  fi
}

logins_from_all_accounts() {
  op account list --format json | jq -r '.[].url' | while read -r account; do
    op item list --account "$account" --categories Login --format json |
      jq --arg account "$account" 'map(. + {account: $account})'
  done | jq -s 'add // []'
}

site_host() {
  local host=${QUTE_URL#*://}
  host=${host%%/*}
  echo "${host#www.}"
}

logins_for_site() {
  jq --arg site "$1" '
    def host: sub("^[a-z]+://"; "") | sub("[/:].*$"; "") | sub("^www\\."; "");
    def same_site($h): $site == $h or ($site | endswith("." + $h)) or ($h | endswith("." + $site));
    [.[] | select(any(.urls[]?.href | host; same_site(.)))]'
}

pick_item() {
  if [[ $(jq length <<<"$1") == 1 ]]; then
    item_reference 0 <<<"$1"
  else
    choose_item "$1"
  fi
}

choose_item() {
  local labels choice line_number
  labels=$(jq -r '.[] | "\(.title)  \(.additional_information // "")  [\(.account | sub("\\.1password\\.com$"; ""))]"' <<<"$1")
  choice=$(choose_from_menu <<<"$labels")
  [[ -n $choice ]] || return 0
  line_number=$(grep -nxF -- "$choice" <<<"$labels" | head -1 | cut -d: -f1)
  item_reference "$((line_number - 1))" <<<"$1"
}

choose_from_menu() {
  local menu_dir
  menu_dir=$(mktemp -d)
  cat >"$menu_dir/choices"
  ghostty --class=local.fsel --gtk-single-instance=false \
    -e fsel-menu "$menu_dir/choices" "$menu_dir/choice" || true
  cat "$menu_dir/choice" 2>/dev/null || true
  rm -rf "$menu_dir"
}

item_reference() {
  jq -r --argjson index "$1" '.[$index] | "\(.account) \(.id)"'
}

fill_login() {
  local item
  item=$(op item get "$2" --account "$1" --format json --reveal)
  send_to_qutebrowser "jseval -q $(fill_command "$item")"
}

fill_command() {
  local username password
  username=$(field_value USERNAME <<<"$1" | base64 -w0)
  password=$(field_value PASSWORD <<<"$1" | base64 -w0)
  echo "(() => { $(tr '\n' ' ' <"$FILL_SCRIPT") qute1pass.fill(\"$(printf %s "$QUTE_URL" | base64 -w0)\", \"$username\", \"$password\"); })();"
}

field_value() {
  jq -j --arg purpose "$1" '[.fields[]? | select(.purpose == $purpose) | .value][0] // ""'
}

copy_totp() {
  local totp
  totp=$(op item get "$2" --account "$1" --otp 2>/dev/null || true)
  [[ -n $totp ]] || return 0
  printf %s "$totp" | wl-copy
  send_to_qutebrowser "message-info \"One-time password copied to clipboard\""
}

main
