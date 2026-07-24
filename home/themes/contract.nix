theme:
let
  fail = message: throw "theme contract violation: ${message}";

  require =
    attrs: label: name:
    attrs.${name} or (fail "missing attribute `${label}.${name}`");

  requireHex =
    attrs: label: name:
    let
      value = require attrs label name;
    in
    if builtins.isString value && builtins.match "[0-9a-f]{6}" value != null then
      value
    else
      fail "`${label}.${name}` must be a 6-character lowercase hex string without `#`";

  requireString =
    attrs: label: name:
    let
      value = require attrs label name;
    in
    if builtins.isString value then value else fail "`${label}.${name}` must be a string";

  requirePath =
    attrs: label: name:
    let
      value = require attrs label name;
    in
    if builtins.isPath value then value else fail "`${label}.${name}` must be a path";

  requireRepo =
    attrs: label: name:
    let
      repo = require attrs label name;
    in
    map (requireString repo "${label}.${name}") [
      "owner"
      "repo"
      "rev"
      "hash"
    ];

  palette = require theme "theme" "palette";
  apps = require theme "theme" "apps";
  ghostty = require apps "theme.apps" "ghostty";
  neovim = require apps "theme.apps" "neovim";
  voxtype = require apps "theme.apps" "voxtype";

  checks = [
    (requireString theme "theme" "font")
    (requirePath theme "theme" "wallpaper")
    (map (requireHex palette "theme.palette") [
      "accent"
      "foreground"
      "background"
      "surface"
      "surfaceLight"
      "separator"
    ])
    (requirePath apps "theme.apps" "btop")
    (requireRepo ghostty "theme.apps.ghostty" "repo")
    (requireString ghostty "theme.apps.ghostty" "themeFile")
    (requireRepo neovim "theme.apps.neovim" "plugin")
    (requireString neovim "theme.apps.neovim" "setup")
    (map (requireHex voxtype "theme.apps.voxtype") [
      "meterLow"
      "meterMid"
      "meterHigh"
    ])
  ];
in
builtins.deepSeq checks theme
