{
  osConfig,
  pkgs,
  ringleader,
  ...
}:

let
  inherit (osConfig.theme) palette;
  colors = osConfig.theme.apps.ringleader;

  toml = pkgs.formats.toml { };

  foreground = color: { fg = color.hex; };

  boldForeground = color: foreground color // { bold = true; };

  theme = {
    base = foreground palette.foreground;
    dim = foreground palette.separator;
    emphasis = boldForeground palette.foreground;
    title = boldForeground palette.accent;
    border = foreground palette.separator;

    selected = {
      fg = palette.foreground.hex;
      bg = palette.surfaceLight.hex;
      bold = true;
    };
    selected_out_of_focus.bg = palette.surface.hex;
    selected_text = {
      fg = palette.background.hex;
      bg = palette.accent.hex;
    };
    prompt = foreground palette.accent;
    accent = boldForeground palette.accent;
    matched = boldForeground palette.accent // {
      underlined = true;
    };
    error = boldForeground palette.alert;
    warning = foreground colors.warning;

    dialog.border = foreground palette.accent;

    diff = {
      insertions = foreground colors.success;
      deletions = foreground palette.alert;
    };

    hint_bar = {
      key = boldForeground palette.accent;
      text = foreground palette.separator;
    };

    state = {
      working = foreground palette.accent;
      waiting = boldForeground colors.warning;
      exited = foreground palette.alert;
    };

    pull_request = {
      open = foreground colors.success;
      merged = foreground colors.merged;
      closed = foreground palette.alert;
    };
  };
in
{
  home.packages = [ ringleader ];

  xdg.configFile."ringleader/theme.toml" = {
    force = true;
    source = toml.generate "ringleader-theme.toml" theme;
  };
}
