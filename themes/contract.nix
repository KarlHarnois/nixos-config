theme:
let
  fail = message: throw "theme contract violation: ${message}";

  require =
    attrs: label: name:
    attrs.${name} or (fail "missing attribute `${label}.${name}`");

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

  requireHex =
    attrs: label: name:
    let
      value = require attrs label name;
    in
    if builtins.isString value && builtins.match "[0-9a-f]{6}" value != null then
      value
    else
      fail "`${label}.${name}` must be a 6-character lowercase hex string without `#`";

  requireColor =
    attrs: label: name:
    let
      hex = requireHex attrs label name;
    in
    {
      hex = "#${hex}";
      rgb = "rgb(${hex})";
      rgba = alpha: "rgba(${hex}${alpha})";
      hexAlpha = alpha: "#${hex}${alpha}";
    };

  requireColors =
    attrs: label: names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = requireColor attrs label name;
      }) names
    );

  requireRepo =
    attrs: label: name:
    let
      field = requireString (require attrs label name) "${label}.${name}";
    in
    {
      owner = field "owner";
      repo = field "repo";
      rev = field "rev";
      hash = field "hash";
    };

  palette = require theme "theme" "palette";
  apps = require theme "theme" "apps";
  ghostty = require apps "theme.apps" "ghostty";
  neovim = require apps "theme.apps" "neovim";
  voxtype = require apps "theme.apps" "voxtype";

  contract = {
    font = requireString theme "theme" "font";
    wallpaper = requirePath theme "theme" "wallpaper";

    palette = requireColors palette "theme.palette" [
      "accent"
      "foreground"
      "background"
      "surface"
      "surfaceLight"
      "separator"
    ];

    apps = {
      btop = requirePath apps "theme.apps" "btop";

      ghostty = {
        repo = requireRepo ghostty "theme.apps.ghostty" "repo";
        themeFile = requireString ghostty "theme.apps.ghostty" "themeFile";
      };

      neovim = {
        plugin = requireRepo neovim "theme.apps.neovim" "plugin";
        setup = requireString neovim "theme.apps.neovim" "setup";
      };

      voxtype = requireColors voxtype "theme.apps.voxtype" [
        "meterLow"
        "meterMid"
        "meterHigh"
      ];
    };
  };
in
builtins.deepSeq contract contract
